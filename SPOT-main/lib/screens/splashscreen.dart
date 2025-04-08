// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:spot/screens/startingpage.dart';
// import 'package:spot/vendor/authentication/login.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// // step 1
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     Future.delayed(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => LoginPage()));
//     });
//   }

// // step 2

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

// // step 3

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       width: double.infinity,
//       height: double.infinity,
//       child: Image.asset(
//         'assets/newSplash.png',
//         fit: BoxFit.cover,
//       ),
//     ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spot/charity/Navbar/charitybottomnavigation.dart';

import 'package:spot/vendor/Navbar/vendorbottomnavigation.dart';
import 'package:spot/vendor/authentication/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Delay the splash screen for 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      // Check if the user is logged in
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch user role from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('CV_users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role']; // Assuming 'role' field in Firestore

          // Navigate to the appropriate screen based on the role
          if (role == 'vendor') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VendorBottomNavbar())); // Replace with actual vendor home page
          } else if (role == 'charity') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CharityBottomNav())); // Replace with actual charity home page
          }
        } else {
          // If the document doesn't exist, navigate to the login page
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      } else {
        // If the user is not logged in, navigate to the login page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/newSplash.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
