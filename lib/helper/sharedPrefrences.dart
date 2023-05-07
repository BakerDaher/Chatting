import 'package:model_chat/data/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  SharedPref._internal() ;
  static final SharedPref _instance = SharedPref._internal() ;
  factory SharedPref(){
    return _instance ;
  }

  late SharedPreferences _preferences ;
  Future<void> initPreferences() async{
    _preferences = await SharedPreferences.getInstance() ;
  }

  // Save info the Acount
  Future<void> saveAcount({required UserM userM }) async {
    await _preferences.setString(preKey.email.toString(), userM.email);
    await _preferences.setString(preKey.passwored.toString(), userM.password);
    await _preferences.setBool(preKey.login.toString(), userM.login);
    await _preferences.setString(preKey.fname.toString(), userM.fname);
    await _preferences.setString(preKey.lname.toString(), userM.lname);
    await _preferences.setString(preKey.uid.toString(), userM.uid );
    await _preferences.setString(preKey.profilePic.toString(), userM.profilePic);
   // await _preferences.setStringList(preKey.groups.toString(), userM.groups );
  }
  Future<void> saveProfilePic({required String profilePic }) async {
    await _preferences.setString(preKey.profilePic.toString(), profilePic);
  }
  Future<void> saveFname({required String fname }) async {
    await _preferences.setString(preKey.fname.toString(), fname);
  }
  Future<void> saveLname({required String lname }) async {
    await _preferences.setString(preKey.lname.toString(), lname);
  }
  Future<void> saveEmail({required String email }) async {
    await _preferences.setString(preKey.email.toString(), email);
  }
  Future<void> savePasswored({required String passwored }) async {
    await _preferences.setString(preKey.passwored.toString(), passwored);
  }
  Future<void> saveLogin({required bool login }) async {
    await _preferences.setBool(preKey.login.toString(), login );
  }

  // get info the acount
  bool get Login => _preferences.getBool(preKey.login.toString()) ?? false ;
  String get Email => _preferences.getString(preKey.email.toString()) ?? '' ;
  String get FName => _preferences.getString(preKey.fname.toString()) ?? '' ;
  String get LName => _preferences.getString(preKey.lname.toString()) ?? '' ;
  String get Passwored => _preferences.getString(preKey.passwored.toString()) ?? '' ;
  String get uid => _preferences.getString(preKey.uid.toString()) ?? '' ;
  String get profilePic => _preferences.getString(preKey.profilePic.toString()) ?? '' ;
 // List get groups => _preferences.getStringList(preKey.groups.toString() ) ?? [] ;

  Future<bool> clear() async {
    bool clear = await _preferences.clear() ;
    return clear ;
  }
}

enum preKey{
  login,email,passwored,fname ,lname,uid , groups , profilePic
}