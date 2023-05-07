import 'package:cloud_firestore/cloud_firestore.dart';
class UserM{
  late String fname ;
  late String lname ;
  late String phone ;
  late String email ;
  late String password ;
  late bool login ;
  late List groups = [] ;
  late String profilePic = "" ;
  late String uid = "" ;

  UserM() ;

  // SaveData in Map >>> to insert D.B >> List<Map>
  // يتم استعمال الميثود كما هيا مع ماب المرجعة و وضعها في ميتود الإنسيرت لانه يدخل ك ماب
  Map<String , dynamic> toMap(){
    Map<String , dynamic> saveData = <String , dynamic>{} ;
    saveData['fname'] = fname ;
    saveData['lname'] = lname ;
    saveData['email'] = email ;
    saveData['groups'] = groups ;
    saveData['profilePic'] = profilePic ;
      return saveData ;
  }

  // fromMapData in Map >>> in readData D.B >> List<Map>
  // ندخل للميثود مخرجات الريد في الداتا بيز
  // كل مرة يستعي اوبجيكت جديد
  UserM.fromFirestore(Map<String , dynamic> data ){
    this.fname = data['fname'] ;
    this.lname = data['lname'] ;
    this.phone = data['phone'] ;
    this.email = data['email'];
  }
}