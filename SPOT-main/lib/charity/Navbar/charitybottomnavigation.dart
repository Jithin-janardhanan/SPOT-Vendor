import 'package:flutter/material.dart';
import 'package:spot/charity/screens/charityProfile.dart';

import 'package:spot/charity/screens/charityhome.dart';

class CharityBottomNav extends StatefulWidget {
  const CharityBottomNav({super.key});

  @override
  State<CharityBottomNav> createState() => _CharityBottomNavState();
}

class _CharityBottomNavState extends State<CharityBottomNav> {
  int indexnum = 0;
  List tabwidgets = [
    CharityHome(),
    Charityprofile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
                backgroundColor: Colors.blue)
          ],
          currentIndex: indexnum,
          showUnselectedLabels: true,
          onTap: (int index) {
            setState(() {
              indexnum = index;
            });
          }),
      body: tabwidgets.elementAt(indexnum),
    );
  }
}
