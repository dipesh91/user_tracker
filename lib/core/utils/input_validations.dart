String? validator({
  required String label,
  required String? value,
  bool canBeNull = false,
}) {
  if (label.toLowerCase().contains('email')) {
    return emailValidation(value);
  } else if (label.toLowerCase().contains('password')) {
    return passwordValidation(value);
  }
  if (canBeNull) {
    return null;
  }
  return defaultValidation(value, label);
}

String? emailValidation(String? value) {
  if (value == null || value.isEmpty) {
    return "Email Can't be Empty";
  } else if (value.contains(RegExp(r'[A-Z]$'))) {
    return "Email must be in lowercase";
  } else if (!value.contains(RegExp(r'@gmail.com$'))) {
    return "email end with @gmail.com";
  } else {
    return null;
  }
}

String? passwordValidation(String? value) {
  if (value == null || value.isEmpty) {
    return "Password Can't be Empty";
  } else if (value.length < 8) {
    return "password minimum length is 8";
  }
  return null;
}

String? defaultValidation(String? value, String label) {
  if (value == null || value.isEmpty) {
    return "$label Can't be Empty";
  }
  return null;
}
