import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

// SignUP
  Future<User?> createUserwithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log('something went wrong');
    }
    return null;
  }

  // SignIn
  Future<User?> loginUserwithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log('something went wrong');
    }
    return null;
  }


  // signOut Funtion
  Future<void> signOut() async{
    try{
      await _auth.signOut();
    }catch(e){
      log("Failed to SignOut");
    }
  }


 
  String getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ?? ''; // If the user is logged in, return email, otherwise an empty string
  }
}

  

