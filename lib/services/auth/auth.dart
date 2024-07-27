import '../../Providers/authproviders.dart';

class Auth {
  String _inputType = '';
  bool showAdditionalFields = false;

  String validateInput(String input) {
    // Regular expression for validating email address
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    // Regular expression for validating phone number (simple version)
    final phoneRegex = RegExp(r'^\+?[0-9]{10,13}$');

    if (emailRegex.hasMatch(input)) {
      return _inputType = 'Email';
    } else if (phoneRegex.hasMatch(input)) {
      return _inputType = 'Phone Number';
    } else {
      return _inputType = 'Invalid Input';
    }
  }
}
