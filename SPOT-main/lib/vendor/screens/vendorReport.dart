
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ShopAnalyticsDashboard extends StatefulWidget {
  const ShopAnalyticsDashboard({super.key});

  @override
  State<ShopAnalyticsDashboard> createState() => _ShopAnalyticsDashboardState();
}

class AnalyticsData {
  final DateTime date;
  final int views;
  final int mapClicks;

  AnalyticsData(this.date, this.views, this.mapClicks);
}

class _ShopAnalyticsDashboardState extends State<ShopAnalyticsDashboard> {
  final CollectionReference reportCollection =
      FirebaseFirestore.instance.collection('shop_analytics_daily');

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Analytics'),
        automaticallyImplyLeading: false,
      ),
      body: userId == null
          ? const Center(child: Text("No user logged in"))
          : StreamBuilder(
              stream: reportCollection
                  .where('vendorId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                  final List<AnalyticsData> chartData = snapshot.data.docs
                      .map<AnalyticsData>((DocumentSnapshot doc) {
                    return AnalyticsData(
                      (doc['timestamp'] as Timestamp).toDate(),
                      doc['views'],
                      doc['mapClicks'],
                    );
                  }).toList();

                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SfCartesianChart(
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.bottom,
                            ),
                            primaryXAxis: DateTimeAxis(
                              dateFormat: DateFormat('MMM dd'),
                              intervalType: DateTimeIntervalType.days,
                              majorGridLines: const MajorGridLines(width: 0),
                              labelRotation: 45,
                            ),
                            primaryYAxis: NumericAxis(
                              axisLine: const AxisLine(width: 0),
                              labelFormat: '{value}',
                              majorTickLines: const MajorTickLines(size: 0),
                            ),
                            series: <CartesianSeries>[
                              ColumnSeries<AnalyticsData, DateTime>(
                                name: 'Views',
                                dataSource: chartData,
                                xValueMapper: (AnalyticsData data, _) =>
                                    data.date,
                                yValueMapper: (AnalyticsData data, _) =>
                                    data.views,
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                ),
                                color: Colors.blue,
                                width: 0.1,
                              ),
                              ColumnSeries<AnalyticsData, DateTime>(
                                name: 'Map Clicks',
                                dataSource: chartData,
                                xValueMapper: (AnalyticsData data, _) =>
                                    data.date,
                                yValueMapper: (AnalyticsData data, _) =>
                                    data.mapClicks,
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  labelAlignment: ChartDataLabelAlignment.top,
                                ),
                                color: Colors.red,
                                width: 0.1,
                                spacing: 0.2,
                              ),
                            ],
                            tooltipBehavior: TooltipBehavior(
                              enable: true,
                              format: 'point.x : point.y',
                            ),
                            zoomPanBehavior: ZoomPanBehavior(
                              enablePinching: true,
                              enablePanning: true,
                              enableDoubleTapZooming: true,
                              enableMouseWheelZooming: true,
                              enableSelectionZooming: true,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot reportSnap =
                                snapshot.data.docs[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      child: ListTile(
                                        leading: Icon(Icons.remove_red_eye),
                                        title: Text(
                                          'Views',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${reportSnap['views']}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      child: ListTile(
                                        leading: Icon(Icons.map),
                                        title: Text(
                                          'Map Clicks',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${reportSnap['mapClicks']}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasData) {
                  return const Center(child: Text('No data available.'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
  }
}
