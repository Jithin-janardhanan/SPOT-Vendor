import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spot/Firbase/auth_service.dart';
import 'package:spot/vendor/authentication/login.dart';
import 'package:spot/vendor/screens/chatlist.dart';
import 'package:spot/vendor/screens/chatscreen.dart';
import 'package:spot/vendor/screens/vendorCharitypage.dart';
import 'package:spot/vendor/screens/vendorProfilepage.dart';
import 'package:spot/vendor/screens/vendorcharityRead.dart';
import 'package:spot/vendor/screens/vendorfeedback.dart';

class VendorBottomNavbar extends StatefulWidget {
  const VendorBottomNavbar({super.key});

  @override
  State<VendorBottomNavbar> createState() => _VendorBottomNavbarState();
}

class _VendorBottomNavbarState extends State<VendorBottomNavbar> {
  int indexnum = 0;
  String? currentVendorId;
  String? currentVendorName;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchVendorData();
  }

  Future<void> _fetchVendorData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentVendorId = user.uid;
      });

      // Fetch vendor details from Firestore
      final vendorDoc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(currentVendorId)
          .get();

      if (vendorDoc.exists) {
        setState(() {
          currentVendorName = vendorDoc.data()?['name'] ?? 'Vendor';
          currentVendorId = vendorDoc.data()?['vendorId'] ?? 'Vendor';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String vendorEmail = _authService.getCurrentUserEmail();

    List<Widget> tabWidgets = [
      const CharityRead(),
      const VendorProfilePage(),
      FeedbackPage(vendorEmail: vendorEmail),
      VendorChatListScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Charity',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feedback',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: indexnum,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            indexnum = index;
          });
        },
      ),
      body: tabWidgets.elementAt(indexnum),
    );
  }

  void gotologin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}

class AuthService {
  String getCurrentUserEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }
}
