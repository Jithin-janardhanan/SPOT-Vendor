import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spot/Firbase/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:spot/vendor/authentication/login.dart';
import 'package:spot/vendor/screens/chatscreen.dart';
import 'package:spot/vendor/screens/vendorReport.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final _firebaseAuth = FirebaseAuth.instance;

  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _emailController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  File? _image;
  String? _imageUrl;

  bool _isEditing = false;
  bool _isSaving = false;
  String _errorMessage = '';

  // Validation patterns

  final _phonePattern = r'^\+?[0-9]{10,12}$';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _emailController = TextEditingController();
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
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
      setState(() {
        _errorMessage = 'Error uploading image: $e';
      });
      return null;
    }
  }

  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() => _isSaving = true);

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in');
      }

      if (_image != null) {
        _imageUrl = await _uploadToCloudinary();
        if (_imageUrl == null) {
          throw Exception('Failed to upload image');
        }
      }

      final data = {
        'name': _nameController.text.trim(),
        'phone': _numberController.text.trim(),
        'email': _emailController.text.trim(),
        'category': _categoryController.text.trim(),
        'Description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'image': _imageUrl ?? '',
      };

      await FirebaseFirestore.instance
          .collection('vendor_reg')
          .doc(currentUser.uid)
          .set(data, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _isSaving = false;
        _isEditing = false;
      });
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Update failed: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _getUserData() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in');
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection('vendor_reg')
          .doc(currentUser.uid)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('User document does not exist');
      }

      return docSnapshot.data() ?? {};
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching user data: ${e.toString()}';
      });
      return {};
    }
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _auth.signOut();
                gotologin(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void gotologin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.spaceMono(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopAnalyticsDashboard(),
                ),
              );
            },
            icon: const Icon(Icons.auto_graph_outlined),
          ),
          IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage.isNotEmpty
                            ? _errorMessage
                            : 'Unable to load user data'),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final user = snapshot.data!;
                if (!_isEditing) {
                  _nameController.text = user['name'] ?? '';
                  _numberController.text = user['phone'] ?? '';
                  _emailController.text = user['email'] ?? '';
                  _categoryController.text = user['category'] ?? '';
                  _descriptionController.text = user['Description'] ?? '';
                  _locationController.text = user['location'] ?? '';
                  _imageUrl = user['image'] ?? '';
                }

                return _buildProfileContent(user);
              },
            ),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : (_imageUrl != null && _imageUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(_imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _imageUrl == null && _image == null
                        ? const Icon(Icons.person, size: 80)
                        : null,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _pickImage,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _buildValidatedTextField(
                controller: _nameController,
                hint: 'Shop Name',
                icon: Icons.storefront,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Shop name is required';
                  }
                  if (value.length < 3) {
                    return 'Shop name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              _buildValidatedTextField(
                  controller: _emailController,
                  hint: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is Empty';
                    }
                    String Pattern = r'^[a-zA-Z0-9._%+-]{1,30}@gmail\.com$';
                    RegExp regex = RegExp(Pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid @gmail.com email (1 to 30 characters before @)';
                    }
                    return null;
                  }),
              _buildValidatedTextField(
                controller: _numberController,
                hint: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }

                  if (!RegExp(_phonePattern).hasMatch(value)) {
                    return 'Please enter a valid phone number (10-12 digits)';
                  }
                  return null;
                },
              ),
              _buildValidatedTextField(
                controller: _categoryController,
                hint: 'Business Category',
                icon: Icons.category,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Business category is required';
                  }
                  return null;
                },
              ),
              _buildValidatedTextField(
                controller: _descriptionController,
                hint: 'Business Description',
                icon: Icons.description,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
              _buildValidatedTextField(
                controller: _locationController,
                hint: 'Business Location',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isEditing
                      ? _updateUserData
                      : () => setState(() => _isEditing = true),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _isEditing
                        ? Colors.green
                        : const Color.fromARGB(255, 8, 43, 72),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _isEditing ? 'Save Changes' : 'Edit Profile',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        readOnly: !_isEditing,
        controller: controller,
        validator: _isEditing ? validator : null,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 8, 43, 72),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 8, 43, 72),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color.fromARGB(255, 5, 62, 81),
          ),
          filled: true,
          fillColor: _isEditing ? Colors.white : Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
        style: TextStyle(
          color: _isEditing ? Colors.black : Colors.black54,
        ),
      ),
    );
  }

  // Add Chat Navigation Method

  // Add Analytics Navigation Method
  void navigateToAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShopAnalyticsDashboard(),
      ),
    );
  }
}
