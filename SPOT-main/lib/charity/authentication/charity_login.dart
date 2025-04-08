
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spot/charity/Navbar/charitybottomnavigation.dart';
import 'package:spot/charity/authentication/charity_sighnup.dart';
import 'package:spot/validation/form_validation.dart';

class CharityLogin extends StatefulWidget {
  const CharityLogin({super.key});

  @override
  State<CharityLogin> createState() => _CharityLoginState();
}

class _CharityLoginState extends State<CharityLogin> {
  final _formKey = GlobalKey<FormState>();
  final FormValidation validation = FormValidation();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true;

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
              const SizedBox(height: 80),
              Image.asset(
                'assets/SplashScreen__1_-removebg-preview.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Charity Login',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Input
                    TextFormField(
                      controller: _emailController,
                      validator: (value) =>
                          validation.EmailValidation(value ?? ''),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        hintText: 'Email',
                        icon: Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Password Input
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) =>
                          validation.PasswordValidation(value ?? ''),
                      decoration: _inputDecoration(
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                      ),
                      obscureText: _isObscured,
                    ),
                    const SizedBox(height: 25),

                    // Login Button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),

                    // Signup Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CharitySighnup(),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      {required String hintText, required IconData icon, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: Colors.green),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final (user, error) =
            await loginUserWithEmailAndPassword(email, password);

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CharityBottomNav(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Login successful!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
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
    super.dispose();
  }
}

class AuthError {
  final String message;
  AuthError(this.message);
}

Future<(User?, AuthError?)> loginUserWithEmailAndPassword(
    String email, String password) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  try {
    final cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return (cred.user, null);
  } on FirebaseAuthException catch (e) {
    return (null, AuthError(_getFirebaseAuthErrorMessage(e)));
  } catch (e) {
    return (null, AuthError('An unexpected error occurred: ${e.toString()}'));
  }
}

String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return 'No user found for that email.';
    case 'wrong-password':
      return 'Invalid password.';
    case 'invalid-email':
      return 'Email address is not valid.';
    case 'user-disabled':
      return 'This user account has been disabled.';
    default:
      return 'An unknown error occurred.';
  }
}
