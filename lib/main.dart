import 'package:flutter/material.dart';
import 'package:model_chat/business_logic/bloc/bloc_Auth.dart';
import 'package:model_chat/business_logic/states.dart';
import 'package:model_chat/helper/app_routes.dart';
import 'package:model_chat/constant/Strings/strings.dart';
import 'package:model_chat/constant/Color/my_Colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:model_chat/helper/sharedPrefrences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized() ;
  await Firebase.initializeApp() ;
  await SharedPref().initPreferences();
  runApp(  ChatApp( appRouter: AppRouter() ));
}

class ChatApp extends StatelessWidget {
  final AppRouter appRouter;
  const ChatApp({Key? key,
    required this.appRouter,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc( initialState() ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "My Chat App",
        theme: ThemeData(
          primaryColor: MyColors.primaryColor ,
          accentColor: MyColors.accentColor,
          scaffoldBackgroundColor: Colors.grey.shade100 ,
          primarySwatch: Colors.grey ,
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 25,
          ),
        ),
        // routes
        // all import to routes can need name Screen
        //  تم النعمييم على كل التطبيقل لإستعمالها على هذه الطريقة
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: lunchScreen ,
      ),
    );
  }
}
