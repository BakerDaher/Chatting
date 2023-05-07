import 'package:flutter/material.dart';
import 'package:model_chat/constant/Strings/strings.dart';
import 'package:model_chat/helper/sharedPrefrences.dart';

class LunchScreen extends StatefulWidget {
  const LunchScreen({Key? key}) : super(key: key);

  @override
  State<LunchScreen> createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration(microseconds: 5000),
      () {
        Navigator.pushReplacementNamed(context, SharedPref().Login ? profilePage : loginScreen ) ;
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Theme.of(context).accentColor,
          Theme.of(context).primaryColor,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: const [0.0, 1.0],
        tileMode: TileMode.clamp,
      )),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(microseconds: 1200),
        child: Center(
          child: Container(
            width: 140.0,
            height: 140.0,
            child: const Center(
              child: ClipOval(
                  child: Icon(
                Icons.mark_unread_chat_alt_outlined,
                size: 140,
                color: Colors.green,
              )),
            ),
          ),
        ),
      ),
    );
  }
}
