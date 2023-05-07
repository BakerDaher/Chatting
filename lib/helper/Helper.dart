import 'package:flutter/material.dart';

class ThemeHelper{
  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 5),
        )
      ],
    );
  }

  AlertDialog alartDialog(String title,String content,   BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black38)),
          onPressed: (){
            Navigator.pop(context) ;
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  showSnackbar(BuildContext context , String text ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor
          ),
        ),
      ),
    );
  }
}