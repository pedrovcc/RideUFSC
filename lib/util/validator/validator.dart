extension Validator on String {
  static final regexEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final regexPassword =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{7,}$');

  bool isValidEmail() {
    return regexEmail.hasMatch(this);
  }

  bool isValidEmailUFSC() {
    return regexEmail.hasMatch(this) && this.contains("@grad.ufsc.br");
  }

  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    return password.length > 7 ? true : false;
  }
}
