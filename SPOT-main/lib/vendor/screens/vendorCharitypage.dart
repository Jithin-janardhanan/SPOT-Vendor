import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:spot/vendor/Navbar/vendorbottomnavigation.dart';
import 'package:spot/vendor/screens/vendorcharityRead.dart';

class VendorCharityPage extends StatefulWidget {
  const VendorCharityPage({super.key});

  @override
  _VendorCharityPageState createState() => _VendorCharityPageState();
}

class _VendorCharityPageState extends State<VendorCharityPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        'P_name': _productNameController.text,
        'P_description': _productDescriptionController.text,
        'quantity': _quantityController.text,
        'phone': _phoneController.text,
        'timestamp': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'notification_flag': true, // To trigger the notification
      };

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VendorBottomNavbar(),
          ));

      // Add the request to Firestore
      await FirebaseFirestore.instance
          .collection('Charity_req')
          .add(requestData);

      // Show local confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donation request submitted successfully!')),
      );

      _clearForm();
    }
  }

  void _clearForm() {
    _productNameController.clear();
    _productDescriptionController.clear();
    _quantityController.clear();
    _phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Charity Form',
          style: GoogleFonts.spaceMono(),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter product name' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _productDescriptionController,
                  decoration: InputDecoration(labelText: 'Product Description'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty
                      ? 'Please enter product description'
                      : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter quantity' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter the number";
                      }
                      String pattern = r'^\+?[0-9]{10,12}$';
                      RegExp regExp = RegExp(pattern);
                      if (!RegExp(pattern).hasMatch(value)) {
                        return 'enter a valid Phone Number';
                      }
                    }),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitRequest,
                  child: Text('Submit Donation Request'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _quantityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
