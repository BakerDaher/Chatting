import 'package:flutter/material.dart';
import 'package:model_chat/presentation/Screen/login_Screen.dart';
import 'package:model_chat/presentation/Screen/lunch_Screen.dart';
import 'package:model_chat/presentation/Screen/searchPage.dart';
import 'package:model_chat/presentation/Screen/sinup_Screen.dart';
import 'package:model_chat/presentation/Screen/profile_page.dart';
import 'package:model_chat/presentation/Screen/forget_password.dart';
import '../constant/Strings/strings.dart';

//! Routes all Screen in Programe
class AppRouter{
  Route generateRoute(RouteSettings settings){
    switch (settings.name) {
      case lunchScreen:
        return MaterialPageRoute(builder: (_) => const LunchScreen());

      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case sinupScreen:
        return MaterialPageRoute(builder: (_) => const SinupScreen());

      case profilePage :
        return MaterialPageRoute(builder: (_) => const ProfilePage() );

      case forgetPassword :
        return MaterialPageRoute(builder: (_) => const ForgetPassword() );

      case searchPage :
        return MaterialPageRoute(builder: (_) => const SearchPage() );
    }
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Text("no route defined"),
      ),
    );
  }
}