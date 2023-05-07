import 'package:flutter/material.dart';
import 'package:model_chat/data/model/User.dart';
import 'package:model_chat/data/repostory_controller/firbase_controller.dart';
import 'package:model_chat/helper/Helper.dart';
import 'package:model_chat/presentation/widgets/HeaderWidget.dart';
import 'package:model_chat/presentation/widgets/button_Box.dart';
import 'package:model_chat/presentation/widgets/text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SinupScreen extends StatefulWidget {
  const SinupScreen({Key? key}) : super(key: key);

  @override
  State<SinupScreen> createState() => _SinupScreenState();
}

class _SinupScreenState extends State<SinupScreen> {
  final _formKey = GlobalKey<FormState>() ;
  bool checkedValue = false;
  bool checkboxValue = false;

  late TextEditingController _email ;
  late TextEditingController _password ;
  late TextEditingController _fname ;
  late TextEditingController _lname ;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController() ;
    _lname = TextEditingController() ;
    _fname = TextEditingController() ;
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose() ;
    _fname.dispose() ;
    _lname.dispose() ;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: HeaderWidget(200, true , Icons.person_add_alt_1_rounded),
            ),
            SafeArea(
              child: Container( // this will be the login form
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children:[
                    Form(
                      // on the send form
                      key: _formKey ,
                      child: Column(
                        children: [
                          text_Field(
                            hintText: "First Name",
                            labelText: "Enter your first name",
                            type: TextInputType.name,
                            text: _fname ,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          text_Field(
                            hintText: "Last Name",
                            labelText: "Enter your last name",
                            type: TextInputType.name,
                            text: _lname ,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          text_Field(
                            hintText: "E-mail address",
                            labelText: "Enter your E-mail address",
                            type: TextInputType.emailAddress,
                            function: (val){
                              if( val!.isEmpty || ( val.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val))){
                                return "Enter a valid email address**";
                              }
                              return null;
                            },
                            text: _email ,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          text_Field(
                            hintText: "Password*",
                            labelText: "Enter your Password*",
                            type: TextInputType.visiblePassword,
                            obscureText: true ,
                            function: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password**";
                              }
                              return null;
                            },
                            text: _password ,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // Accept *********************************************************
                          FormField<bool>(
                            builder: (state){
                              return Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                          value: checkboxValue,
                                          onChanged: (value) {
                                            setState(() {
                                              checkboxValue = value!;
                                              state.didChange(value);
                                            });
                                          }),
                                      Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey),),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      state.errorText ?? '',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                                    ),
                                  ) ,
                                ],
                              );
                            },
                            validator: (value) {
                              if (!checkboxValue) {
                                return 'You need to accept terms and conditions';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 20.0),
                          Button_Box(
                            text: "Sign in",
                            fun: (){
                              // check the form Valid or notValid
                              // in all validator inside Forn >> key = _formKey
                              if (_formKey.currentState!.validate() ){
                                _sinup() ;
                              }
                            },
                          ),
                          // soshial media
                          SizedBox(height: 20.0),
                          Text("Or create account using social media",  style: TextStyle(color: Colors.grey),),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                // liblary Icon in Google
                                child: const FaIcon(
                                  FontAwesomeIcons.googlePlus,
                                  size: 35,
                                  color: Color(0xffEC2D2F),
                                ),
                                onTap: () {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ThemeHelper().alartDialog("Google Plus","You tap on GooglePlus social icon.",context);
                                      },
                                    );
                                  });
                                },
                              ),
                              const SizedBox(width: 30.0,),
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      width: 5,
                                      color: const Color(0xff40ABF0),
                                    ),
                                    color: const Color(0xff40ABF0),
                                  ),
                                  child: const FaIcon(
                                    FontAwesomeIcons.twitter,
                                    size: 23,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ThemeHelper().alartDialog("Twitter","You tap on Twitter social icon.",context);
                                      },
                                    );
                                  });
                                },
                              ),
                              const SizedBox(width: 30.0,),
                              GestureDetector(
                                child: const FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 35,
                                  color: Color(0xff3E529C),

                                ),
                                onTap: () {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ThemeHelper().alartDialog("Facebook",
                                            "You tap on Facebook social icon.",
                                            context);
                                      },
                                    );
                                  });
                                },
                              ),
                            ],
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

  Future<void> _sinup() async {
    bool register = await FBController().createAcount(userM: userM() , context: context) ;
    if(register){
      Navigator.pop(context) ;
    }
  }

  UserM userM(){
    UserM userM = UserM() ;
    userM.login = false ;
    userM.fname = _fname.text ;
    userM.lname = _lname.text ;
    userM.email = _email.text ;
    userM.password = _password.text ;
    return userM ;
  }
}