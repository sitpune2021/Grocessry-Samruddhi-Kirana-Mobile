class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter full name";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter mobile number";
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Enter valid 10-digit number";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return "Enter valid email";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter password";
    }
    if (value.length < 8) {
      return "Minimum 8 characters required";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Add 1 uppercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Add 1 number";
    }
    return null;
  }

  String? otpValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Enter OTP";
  }
  if (value.length != 6) {
    return "Invalid OTP";
  }
  return null;
}

}
