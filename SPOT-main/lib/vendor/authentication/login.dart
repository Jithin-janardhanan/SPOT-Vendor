// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:spot/vendor/authentication/signup.dart';
// import 'package:spot/vendor/Navbar/vendorbottomnavigation.dart';
// import 'package:spot/validation/form_validation.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final FormValidation _validation = FormValidation();
//   bool _isLoading = false;
//   bool _isObscured = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   static const Color primaryColor = Color(0xFF3D82DB);
//   static const Color backgroundColor = Color(0xFFF5F5F5);
//   static const Color textColor = Colors.white;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/SplashScreen__1_-removebg-preview.png',
//                   height: 150,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Vendor Login',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: primaryColor,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       _buildTextField(
//                         controller: _emailController,
//                         hintText: 'Email',
//                         icon: Icons.email,
//                         validator: (value) =>
//                             _validation.EmailValidation(value ?? ''),
//                       ),
//                       const SizedBox(height: 15),
//                       _buildTextField(
//                         controller: _passwordController,
//                         hintText: 'Password',
//                         icon: Icons.lock,
//                         obscureText: _isObscured,
//                         validator: (value) =>
//                             _validation.PasswordValidation(value ?? ''),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isObscured
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                           ),
//                           onPressed: () {
//                             setState(() => _isObscured = !_isObscured);
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _isLoading
//                           ? CircularProgressIndicator(color: primaryColor)
//                           : _buildLoginButton(),
//                       const SizedBox(height: 20),
//                       _buildSignupOption(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     bool obscureText = false,
//     String? Function(String?)? validator,
//     Widget? suffixIcon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       validator: validator,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.white,
//         hintText: hintText,
//         prefixIcon: Icon(icon, color: primaryColor),
//         suffixIcon: suffixIcon,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginButton() {
//     return MaterialButton(
//       minWidth: double.infinity,
//       onPressed: _login,
//       child: const Text('Login', style: TextStyle(fontSize: 18)),
//       color: primaryColor,
//       textColor: textColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     );
//   }

//   Widget _buildSignupOption() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("Don't have an account?"),
//         TextButton(
//           onPressed: () => Navigator.push(
//               context, MaterialPageRoute(builder: (context) => Signup())),
//           child: Text('SIGNUP',
//               style:
//                   TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
//         ),
//       ],
//     );
//   }

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         UserCredential userCredential =
//             await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );

//         final userId = userCredential.user!.uid;
//         final customerDoc = await FirebaseFirestore.instance
//             .collection('customer_login')
//             .doc(userId)
//             .get();
//         final charityDoc = await FirebaseFirestore.instance
//             .collection('charity_login')
//             .doc(userId)
//             .get();

//         if (customerDoc.exists || charityDoc.exists) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => vebdorBottomNavbar()),
//           );
//           return;
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No user found for this email')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Login failed: $e')),
//         );
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
// }
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:spot/charity/Navbar/charitybottomnavigation.dart';
// import 'package:spot/vendor/Navbar/vendorbottomnavigation.dart';
// import 'package:spot/vendor/authentication/signup.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Image.asset(
//                 'assets/SplashScreen__1_-removebg-preview.png',
//                 height: 150,
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: const Icon(Icons.email),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Email is required';
//                   }
//                   if (!value.contains('@') || !value.contains('.')) {
//                     return 'Enter a valid email address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Password is required';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _login,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Text(
//                         'Login',
//                         style: TextStyle(fontSize: 16),
//                       ),
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SignupPage()),
//                   );
//                 },
//                 child: const Text('Don\'t have an account? Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (!mounted) return;

//       if (userCredential.user == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Login failed: User not found')),
//         );
//         setState(() => _isLoading = false);
//         return;
//       }

//       final String userId = userCredential.user!.uid;
//       final DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('CV_users')
//           .doc(userId)
//           .get();

//       if (!mounted) return;

//       if (!userDoc.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('User profile not found')),
//         );
//         setState(() => _isLoading = false);
//         return;
//       }

//       final Map<String, dynamic> userData =
//           userDoc.data() as Map<String, dynamic>;
//       final String role = userData['role'] ?? '';

//       if (role == 'vendor') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const vebdorBottomNavbar()),
//         );
//       } else if (role == 'charity') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const CharityBottomNav()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid user role')),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       String message;
//       switch (e.code) {
//         case 'user-not-found':
//           message = 'No user found with this email.';
//           break;
//         case 'wrong-password':
//           message = 'Wrong password provided.';
//           break;
//         case 'invalid-email':
//           message = 'The email address is badly formatted.';
//           break;
//         case 'user-disabled':
//           message = 'This user account has been disabled.';
//           break;
//         default:
//           message = 'An error occurred. Please try again.';
//       }

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//       log('Login error: ${e.code}');
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Login error: $e')),
//       );
//       log('Login error: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spot/charity/Navbar/charitybottomnavigation.dart';
import 'package:spot/vendor/Navbar/vendorbottomnavigation.dart';
import 'package:spot/vendor/authentication/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 5, 62, 81),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/SplashScreen__1_-removebg-preview.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 5, 62, 81),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black87),
                  prefixIcon: const Icon(Icons.email,
                      color: Color.fromARGB(255, 5, 62, 81)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black87),
                  prefixIcon: const Icon(Icons.lock,
                      color: Color.fromARGB(255, 5, 62, 81)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color.fromARGB(255, 5, 62, 81),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 5, 62, 81),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                      color: Color.fromARGB(255, 5, 62, 81),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (userCredential.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed: User not found')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final String userId = userCredential.user!.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('CV_users')
          .doc(userId)
          .get();

      if (!mounted) return;

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User profile not found')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
      final String role = userData['role'] ?? '';

      if (role == 'vendor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VendorBottomNavbar()),
        );
      } else if (role == 'charity') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CharityBottomNav()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid user role')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      log('Login error: ${e.code}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e')),
      );
      log('Login error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
