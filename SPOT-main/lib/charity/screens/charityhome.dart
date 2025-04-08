
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharityHome extends StatefulWidget {
  const CharityHome({super.key});

  @override
  State<CharityHome> createState() => _CharityHomeState();
}

class _CharityHomeState extends State<CharityHome> {
  @override
  void initState() {
    super.initState();
    // Check user role before setting up notification listener
    _checkRoleAndSetupNotifications();
  }

  Future<void> _checkRoleAndSetupNotifications() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('CV_users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && userDoc.data()?['role'] == 'charity') {
        _listenForCharityRequests();
      }
    }
  }

  void _listenForCharityRequests() {
    FirebaseFirestore.instance
        .collection('Charity_req')
        .where('notification_flag', isEqualTo: true)
        .snapshots()
        .listen((snapshot) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Get user role
      final userDoc = await FirebaseFirestore.instance
          .collection('CV_users')
          .doc(currentUser.uid)
          .get();

      // Only proceed if user is a charity
      if (userDoc.exists && userDoc.data()?['role'] == 'charity') {
        for (var doc in snapshot.docs) {
          _triggerNotification(doc['P_name']);

          // Remove notification flag after processing
          await FirebaseFirestore.instance
              .collection('Charity_req')
              .doc(doc.id)
              .update({'notification_flag': false});
        }
      }
    });
  }

  void _triggerNotification(String productName) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'spot',
        title: 'New Donation Request',
        body: 'You have a donation request for $productName',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference charityReq =
        FirebaseFirestore.instance.collection('Charity_req');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charity Home'),
      ),
      body: StreamBuilder(
        stream: charityReq.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot charitySnap = snapshot.data.docs[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.volunteer_activism,
                                color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              charitySnap['P_name'],
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          charitySnap['P_description'],
                          style: GoogleFonts.roboto(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Contact Number : ${charitySnap['phone']}',
                          style: GoogleFonts.roboto(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Quantity: ${charitySnap['quantity']}',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
