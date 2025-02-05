// ignore_for_file: non_constant_identifier_names

class FormValidation {
  // Password validation method
  String? PasswordValidation(String value) {
    // Password must be at least 5 characters long
    RegExp condition = RegExp(r'^.{5,}$');
    if (value.isEmpty) {
      return "Password is empty";
    } else if (!condition.hasMatch(value)) {
      return "Password must be at least 5 characters long";
    } else {
      return null;
    }
  }

  // Email validation method
  String? EmailValidation(String value) {
    // Email pattern for @gmail.com
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@gmail\.com$';
    RegExp email = RegExp(emailPattern);

    if (value.isEmpty) {
      return "Email is empty";
    } else if (!email.hasMatch(value)) {
      return "Enter a valid Gmail address";
    } else {
      return null;
    }
  }

  
  String? UserValidation(String value) {
    RegExp condition = RegExp(r'^.{4,}$');
    if (value.isEmpty) {
      return "Email is empty";
    } else if (!condition.hasMatch(value)) {
      return "Enter a valid Username";
    } else {
      return null;
    }
  }

  }

