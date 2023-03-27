class InputValidator {
  static bool isEnailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isPhoneValid(String phone) {
    return RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(phone);
  }
}
