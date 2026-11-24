class Validators {
  const Validators._();

  static final RegExp passwordPattern = RegExp(
    r'^(?=.{6,10}$)(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).*$',
  );

  static final RegExp _emailPattern = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Please enter your email address';
    }
    if (!_emailPattern.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? requiredText(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!passwordPattern.hasMatch(value)) {
      return 'Use 6-10 characters with upper, lower, digit and symbol';
    }
    return null;
  }

  static String? egyptianPhone(String? value) {
    final digits = digitsOnly(value ?? '');
    if (digits.isEmpty) {
      return 'Please enter your phone number';
    }
    if (digits.length != 10 || !digits.startsWith('1')) {
      return 'Enter a valid 10-digit Egyptian mobile number';
    }
    return null;
  }

  static String digitsOnly(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }
}
