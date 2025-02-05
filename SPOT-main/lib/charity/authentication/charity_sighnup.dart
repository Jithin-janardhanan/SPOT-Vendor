// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:spot/charity/authentication/charity_login.dart';
// import 'package:spot/charity/screens/charityRegistration.dart';
// import 'package:spot/validation/form_validation.dart';

// class CharitySighnup extends StatefulWidget {
//   const CharitySighnup({super.key});

//   @override
//   State<CharitySighnup> createState() => _CharitySighnupState();
// }

// class _CharitySighnupState extends State<CharitySighnup> {
//   final _emailcontroller = TextEditingController();
//   final _passwordcontroller = TextEditingController();
//   final _namecontroller = TextEditingController();
//   final _formKey = GlobalKey<FormState>(); //declaring valitions for forms
//   final FormValidation validation =
//       FormValidation(); //declaring or imprting the class

//   bool _isObscured = true;
//   bool _isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 81, 19, 19),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset('assets/SplashScreen__1_-removebg-preview.png'),
//             Text(
//               'Charity SignUp',
//               style: TextStyle(
//                 fontSize: 35,
//                 color: const Color.fromARGB(255, 64, 219, 61),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30),

//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30),
//                       child: TextFormField(
//                         controller: _emailcontroller,
//                         validator: (value) =>
//                             validation.EmailValidation(value ?? ''),
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           hintText: 'Enter email',
//                           prefixIcon: Icon(Icons.email),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 30),
//                         child: TextFormField(
//                           controller: _passwordcontroller,
//                           validator: (value) =>
//                               validation.PasswordValidation(value ?? ''),
//                           decoration: InputDecoration(
//                             hintText: 'password',
//                             filled: true,
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                             prefixIcon: const Icon(Icons.lock_outline),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isObscured
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isObscured = !_isObscured;
//                                 });
//                               },
//                             ),
//                           ),
//                           obscureText: _isObscured,
//                         )),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                       child: MaterialButton(
//                           minWidth: double.maxFinite,
//                           onPressed: _signup,
//                           color: Color.fromARGB(255, 64, 219, 61),
//                           textColor: const Color.fromARGB(255, 254, 254, 254),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Text(
//                             'SignUp',
//                             style: TextStyle(color: Colors.white),
//                           )),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Alredy have an account",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CharityLogin()));
//                             },
//                             child: Text(
//                               'LOGIN',
//                               style: TextStyle(color: Colors.amber),
//                             ))
//                       ],
//                     )
//                   ],
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _signup() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         // Create user in Firebase Authentication
//         UserCredential userCredential =
//             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailcontroller.text.trim(),
//           password: _passwordcontroller.text,
//         );

//         // Save user data to Firestore
//         await FirebaseFirestore.instance
//             .collection('charity_login')
//             .doc(userCredential.user!.uid)
//             .set({
//           'name': _namecontroller.text.trim(),
//           'email': _emailcontroller.text.trim(),
//         });

//         // Notify user and navigate to Homepage
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Signup successful!')),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CharityRegistration()),
//         );
//       } catch (e) {
//         // log("Error during signup: $e");
//         // log('error $e');
//         log('error $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Signup failed: $e")),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _emailcontroller.dispose();
//     _passwordcontroller.dispose();
//     _namecontroller.dispose();
//     super.dispose();
//   }
// }
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot/charity/authentication/charity_login.dart';
import 'package:spot/charity/screens/charityRegistration.dart';
import 'package:spot/validation/form_validation.dart';

class CharitySighnup extends StatefulWidget {
  const CharitySighnup({super.key});

  @override
  State<CharitySighnup> createState() => _CharitySighnupState();
}

class _CharitySighnupState extends State<CharitySighnup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FormValidation validation = FormValidation();

  bool _isObscured = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/SplashScreen__1_-removebg-preview.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Charity SignUp',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Input
                    _buildInputField(
                      controller: _nameController,
                      hintText: 'Full Name',
                      icon: Icons.person_outline,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your full name'
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Email Input
                    _buildInputField(
                      controller: _emailController,
                      hintText: 'Enter email',
                      icon: Icons.email_outlined,
                      validator: (value) =>
                          validation.EmailValidation(value ?? ''),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),

                    // Password Input
                    _buildInputField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      isObscure: _isObscured,
                      validator: (value) =>
                          validation.PasswordValidation(value ?? ''),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 25),

                    // SignUp Button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),

                    // Redirect to Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CharityLogin(),
                              ),
                            );
                          },
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.green),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('charity_login')
            .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CharityRegistration()),
        );
      } catch (e) {
        log('Signup failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed: $e")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
