class Validation{
  static bool isVaildEmail(String? email){
  if(email == null || email.trim().isEmpty){
    return false;
  }
  final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  return emailValid;
}
  static bool validatePassword(String? password) {
    if (password == null || password.trim().isEmpty){
      return false;
    }
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }
}