import 'package:flutter/material.dart';

class text_Field extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextInputType type;
  final bool? obscureText ;
  final String? Function(String? val)? function;
  final TextEditingController text ;

  const text_Field({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.type,
    this.obscureText,
    this.function,
    required this.text ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextFormField(
        keyboardType: type,
        obscureText: obscureText ?? false ,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          fillColor: Colors.white,
          filled: true,
          hintStyle: const TextStyle(
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide: BorderSide(color: Colors.grey.shade400)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide:const BorderSide(color: Colors.red, width: 2.0)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.0),
              borderSide:const BorderSide(color: Colors.red, width: 2.0)),
        ) ,
        validator: function ,
        controller: text ,
      ),
    );
  }
}
