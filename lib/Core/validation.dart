class Validation{
  static bool isVaildEmail(String? email){
  if(email == null || email.trim().isEmpty){
    return false;
  }
  final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  return emailValid;
}
}