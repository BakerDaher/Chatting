import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:model_chat/constant/Strings/strings.dart';
import 'package:model_chat/data/repostory_controller/firbase_controller.dart';
import 'package:model_chat/helper/sharedPrefrences.dart';
import 'package:model_chat/presentation/widgets/HeaderWidget.dart';
import 'package:model_chat/presentation/widgets/button_Box.dart';
import 'package:model_chat/presentation/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //AuthService authService = AuthService();
  final double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>() ;
  late TextEditingController _email ;
  late TextEditingController _password ;
  bool _isLoading = false;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController() ;
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose() ;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading ?
      Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor
        ),
      ) :
      SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true , Icons.login_rounded),
            ),
            SafeArea(
              child: Container( // this will be the login form
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children:[
                    const Text(
                      "Hello",
                      style: TextStyle(fontSize: 40 ,fontWeight: FontWeight.bold ),
                    ),
                    const SizedBox(height: 5,),
                    const Text(
                      "Signing into your account",
                      style: TextStyle(color: Colors.grey ),
                    ),
                    const SizedBox(height: 30,),
                    Form(
                      key: _formKey ,
                      child: Column(
                        children: [
                          text_Field(
                            hintText: "Email",
                            labelText: "Enter your email",
                            type: TextInputType.emailAddress,
                            function: (val){
                              // ignore: prefer_is_not_empty
                              if( val!.isEmpty ||  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                            text: _email ,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          text_Field(
                            hintText: "Password",
                            labelText: "Enter your password",
                            type: TextInputType.visiblePassword,
                            obscureText: true ,
                            function: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              else if ( val.length < 6 ){
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            text: _password ,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                              child: RichText(
                                text: TextSpan(
                                  text: "",
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Forget your Password?",
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            Navigator.pushNamed(context, forgetPassword),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Button_Box(
                            text: "Sign in",
                            fun: () async {
                              if (_formKey.currentState!.validate() ){
                                await _login() ;
                              }
                            },
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Create",
                                      style:  TextStyle(
                                        color: Colors.blue ,
                                        fontWeight: FontWeight.bold ,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () =>
                                            Navigator.pushNamed(context, sinupScreen),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    String email = _email.text ;
    String passwored = _password.text ;
    bool register = await FBController().login(email: email, password: passwored, context: context) ;
    if(register){
      await FirebaseFirestore.instance.
      collection('user')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          // docs >> Search by user key
          // Converts users to a List and searches in it by columns
          if ( await doc["email"] == email){
            SharedPref().saveLogin(login: true );
            SharedPref().savePasswored(passwored: passwored) ;
            SharedPref().saveEmail(email: email) ;
            SharedPref().saveFname(fname: await doc["fname"] ) ;
            SharedPref().saveLname(lname:  await doc["lname"]) ;
            SharedPref().saveProfilePic(profilePic: await doc["profilePic"]) ;
            return ;
          }
        });
      });
      await Navigator.pushReplacementNamed(context,  profilePage ) ;
    }else{
      setState(() {
        _isLoading = false;
      });
    }
  }
}