// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:spot/Firbase/auth_service.dart';
// import 'package:spot/charity/authentication/charity_login.dart';
// import 'package:spot/vendor/authentication/login.dart';

// class Charityprofile extends StatefulWidget {
//   const Charityprofile({super.key});

//   @override
//   State<Charityprofile> createState() => _CharityprofileState();
// }

// class _CharityprofileState extends State<Charityprofile> {
//   @override
//   final _auth = AuthService();
//   final _firebaseAuth = FirebaseAuth.instance;

//   late TextEditingController _nameController;
//   late TextEditingController _numberController;
//   late TextEditingController _emailController;
//   late TextEditingController _categoryController;

//   File? _image;
//   String? _imageUrl;

//   bool _isEditing = false;
//   bool _isSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _numberController = TextEditingController();
//     _emailController = TextEditingController();
//     _categoryController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _numberController.dispose();
//     _emailController.dispose();
//     _categoryController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Future<String?> _uploadToCloudinary() async {
//     if (_image == null) return null;

//     try {
//       final url = Uri.parse('https://api.cloudinary.com/v1_1/datygsam7/upload');
//       final request = http.MultipartRequest('POST', url);

//       request.fields['upload_preset'] = 'SpotApplication';
//       request.files
//           .add(await http.MultipartFile.fromPath('file', _image!.path));

//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.toBytes();
//         final responseString = String.fromCharCodes(responseData);
//         final jsonMap = jsonDecode(responseString);
//         return jsonMap['secure_url'] as String;
//       } else {
//         throw HttpException('Upload failed with status ${response.statusCode}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading image: $e')),
//       );
//       return null;
//     }
//   }

//   Future<void> _updateUserData() async {
//     final currentUser = _firebaseAuth.currentUser;
//     if (currentUser == null) {
//       throw Exception('No user is currently signed in.');
//     }

//     if (_image != null) {
//       _imageUrl = await _uploadToCloudinary();
//       if (_imageUrl == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to upload image')),
//         );
//         return;
//       }
//     }

//     final data = {
//       'name': _nameController.text,
//       'number': _numberController.text,
//       'email': _emailController.text,
//       'category': _categoryController.text,
//       'image': _imageUrl ?? '',
//     };

//     await FirebaseFirestore.instance
//         .collection('charity_reg')
//         .doc(currentUser.uid)
//         .set(data, SetOptions(merge: true));

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Profile updated successfully')),
//     );
//   }

//   Future<DocumentSnapshot> _getUserData() async {
//     final currentUser = _firebaseAuth.currentUser;
//     if (currentUser == null) {
//       throw Exception('No user is currently signed in.');
//     }
//     return FirebaseFirestore.instance
//         .collection('charity_reg')
//         .doc(currentUser.uid)
//         .get();
//   }

//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Log Out'),
//           content: const Text('Do you want to log out?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('No'),
//             ),
//             TextButton(
//               onPressed: () {
//                 gotologin(context);
//                 _auth.signOut();
//               },
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Page'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () async {
//               _showLogoutDialog();
//             },
//             icon: Icon(Icons.logout_sharp),
//           )
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: _isSaving
//           ? const Center(child: CircularProgressIndicator())
//           : FutureBuilder<DocumentSnapshot>(
//               future: _getUserData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('Error fetching user data.'));
//                 }
//                 if (!snapshot.hasData || !snapshot.data!.exists) {
//                   return const Center(child: Text('User data not found.'));
//                 }

//                 final user = snapshot.data!.data() as Map<String, dynamic>;

//                 if (!_isEditing) {
//                   _nameController.text = user['name'] ?? '';
//                   _numberController.text = user['number'] ?? '';
//                   _emailController.text = user['email'] ?? '';
//                   _categoryController.text = user['category'] ?? '';
//                   _imageUrl = user['image'] ?? '';
//                 }

//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: 50,
//                               backgroundImage: _image != null
//                                   ? FileImage(_image!)
//                                   : (_imageUrl != null && _imageUrl!.isNotEmpty
//                                       ? NetworkImage(_imageUrl!)
//                                       : null) as ImageProvider?,
//                               child: _imageUrl == null && _image == null
//                                   ? const Icon(Icons.person, size: 50)
//                                   : null,
//                             ),
//                             if (_isEditing)
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: IconButton(
//                                   icon: const Icon(Icons.edit,
//                                       color: Colors.blue),
//                                   onPressed: _pickImage,
//                                 ),
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),
//                         TextFormField(
//                             readOnly: !_isEditing,
//                             controller: _nameController,
//                             decoration:
//                                 _inputDecoration('Username', Icons.person)),
//                         const SizedBox(height: 15),
//                         TextField(
//                             readOnly: !_isEditing,
//                             controller: _emailController,
//                             decoration: _inputDecoration('Email', Icons.email)),
//                         const SizedBox(height: 15),
//                         TextField(
//                             readOnly: !_isEditing,
//                             controller: _numberController,
//                             decoration: _inputDecoration('Phone', Icons.phone)),
//                         const SizedBox(height: 20),
//                         TextField(
//                           readOnly: !_isEditing,
//                           controller: _categoryController,
//                           decoration:
//                               _inputDecoration('Category', Icons.category),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         ElevatedButton(
//                           onPressed: () async {
//                             if (_isEditing) {
//                               setState(() => _isSaving = true);
//                               await _updateUserData();
//                               setState(() {
//                                 _isSaving = false;
//                                 _isEditing = false;
//                               });
//                             } else {
//                               setState(() => _isEditing = true);
//                             }
//                           },
//                           child: Text(_isEditing ? 'Save' : 'Edit'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   InputDecoration _inputDecoration(String hint, IconData icon) {
//     return InputDecoration(
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       hintText: hint,
//       prefixIcon: Icon(icon),
//     );
//   }
// }

// gotologin(BuildContext context) {
//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(builder: (context) => LoginPage()),
//     (Route<dynamic> route) => false, // Remove all previous routes
//   );
// }
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spot/Firbase/auth_service.dart';
import 'package:spot/charity/authentication/charity_login.dart';
import 'package:spot/vendor/authentication/login.dart';

class Charityprofile extends StatefulWidget {
  const Charityprofile({super.key});

  @override
  State<Charityprofile> createState() => _CharityprofileState();
}

class _CharityprofileState extends State<Charityprofile> {
  @override
  final _auth = AuthService();
  final _firebaseAuth = FirebaseAuth.instance;

  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _emailController;
  late TextEditingController _categoryController;

  File? _image;
  String? _imageUrl;

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _emailController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadToCloudinary() async {
    if (_image == null) return null;

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/datygsam7/upload');
      final request = http.MultipartRequest('POST', url);

      request.fields['upload_preset'] = 'SpotApplication';
      request.files
          .add(await http.MultipartFile.fromPath('file', _image!.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'] as String;
      } else {
        throw HttpException('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  Future<void> _updateUserData() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    if (_image != null) {
      _imageUrl = await _uploadToCloudinary();
      if (_imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
        return;
      }
    }

    final data = {
      'name': _nameController.text,
      'number': _numberController.text,
      'email': _emailController.text,
      'category': _categoryController.text,
      'image': _imageUrl ?? '',
    };

    await FirebaseFirestore.instance
        .collection('charity_reg')
        .doc(currentUser.uid)
        .set(data, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  Future<DocumentSnapshot> _getUserData() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }
    return FirebaseFirestore.instance
        .collection('charity_reg')
        .doc(currentUser.uid)
        .get();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Do you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                gotologin(context);
                _auth.signOut();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              _showLogoutDialog();
            },
            icon: Icon(Icons.logout_sharp),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<DocumentSnapshot>(
              future: _getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching user data.'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('User data not found.'));
                }

                final user = snapshot.data!.data() as Map<String, dynamic>;

                if (!_isEditing) {
                  _nameController.text = user['name'] ?? '';
                  _numberController.text = user['number'] ?? '';
                  _emailController.text = user['email'] ?? '';
                  _categoryController.text = user['category'] ?? '';
                  _imageUrl = user['image'] ?? '';
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : (_imageUrl != null && _imageUrl!.isNotEmpty
                                      ? NetworkImage(_imageUrl!)
                                      : null) as ImageProvider?,
                              child: _imageUrl == null && _image == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: _pickImage,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                            'Username', Icons.person, _nameController),
                        const SizedBox(height: 15),
                        _buildTextField('Email', Icons.email, _emailController),
                        const SizedBox(height: 15),
                        _buildTextField(
                            'Phone', Icons.phone, _numberController),
                        const SizedBox(height: 15),
                        _buildTextField(
                            'Category', Icons.category, _categoryController),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_isEditing) {
                              setState(() => _isSaving = true);
                              await _updateUserData();
                              setState(() {
                                _isSaving = false;
                                _isEditing = false;
                              });
                            } else {
                              setState(() => _isEditing = true);
                            }
                          },
                          child: Text(_isEditing ? 'Save' : 'Edit'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      readOnly: !_isEditing,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon),
      ),
    );
  }
}

gotologin(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (Route<dynamic> route) => false, // Remove all previous routes
  );
}
