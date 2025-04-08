import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spot/screens/splashscreen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:spot/theme/app_theme.dart';
import 'package:spot/vendor/screens/chatlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'spot',
        channelGroupKey: 'group key',
        channelName: 'Spot',
        channelDescription: 'TECHFIFO')
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'group key', channelGroupName: 'Techfifo group'),
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spot 1',
        themeMode: ThemeMode.system,
        theme: AppTheme.light,
        home: SplashScreen());
  }
}
