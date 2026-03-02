class FormValidators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    // Strict check: Exactly 10 digits
    final mobileRegex = RegExp(r'^[0-9]{10}$');
    if (!mobileRegex.hasMatch(value.replaceAll(RegExp(r'\D'), ''))) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  static String? optionalMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    return mobile(value);
  }

  static String? telephone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telephone number is required';
    }
    // Looser check: Min 6 digits, allows longer, no +91 restriction
    final phoneRegex = RegExp(r'^[0-9]{6,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\D'), ''))) {
      return 'Please enter a valid telephone number (6-15 digits)';
    }
    return null;
  }

  static String? optionalTelephone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    return telephone(value);
  }

  static String? internationalPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    // International numbers can vary, typically 7-15 digits
    final phoneRegex = RegExp(r'^[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\D'), ''))) {
      return 'Please enter a valid mobile number (7-15 digits)';
    }
    return null;
  }

  static String? pincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    final pincodeRegex = RegExp(r'^[0-9]{6}$');
    if (!pincodeRegex.hasMatch(value)) {
      return 'Please enter a valid 6-digit pincode';
    }
    return null;
  }

  static String? internationalPincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    // Most international postal codes are 3-10 alphanumeric characters
    final pincodeRegex = RegExp(r'^[a-zA-Z0-9\s-]{3,10}$');
    if (!pincodeRegex.hasMatch(value.trim())) {
      return 'Please enter a valid postal code';
    }
    return null;
  }
}
