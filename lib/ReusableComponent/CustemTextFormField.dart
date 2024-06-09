import 'package:flutter/material.dart';

class CustemTextFormField extends StatelessWidget {
   CustemTextFormField({this.decoration,required this.validator,required this.controller,this.maxLines,this.minLines,  this.keyboardType});
  InputDecoration? decoration;
  TextEditingController? controller;
   String? Function(String?)? validator;
   int? maxLines ;
   int? minLines;
   TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      decoration: decoration,
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}
