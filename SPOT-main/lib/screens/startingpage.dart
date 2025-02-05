import 'package:flutter/material.dart';
import 'package:spot/charity/authentication/charity_login.dart';
import 'package:spot/vendor/authentication/login.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B), // Dark modern background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Title
            Text(
              "SPOT",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4CAF50), // Bright green accent
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 50),

            // Vendor Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // Bright green button
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text(
                "Vendor",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Text color
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Customer Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3), // Bright blue button
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharityLogin()),
                );
              },
              child: const Text(
                "Charity",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Text color
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Footer Text
            const Text(
              "Welcome to SPOT, your one-stop solution!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


