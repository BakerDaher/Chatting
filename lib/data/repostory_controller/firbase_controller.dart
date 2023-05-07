import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model_chat/data/model/User.dart';
import 'package:model_chat/helper/Helper.dart';

// Sinup // Login // Logout // Change_Passwored // GetGroupesof only user // view Exception
class FBController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Create
  Future<bool> createAcount(
      {required UserM userM, required BuildContext context}) async {
    try {
      UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
          email: userM.email, password: userM.password ) ;

      // A [FirebaseAuthException] maybe thrown with the following error code:
      // - **email-already-in-use**:
      //  - Thrown if there already exists an account with the given email address.
      // - **invalid-email**:
      //  - Thrown if the email address is not valid.
      // - **operation-not-allowed**:
      //  - Thrown if email/password accounts are not enabled. Enable
      //    email/password accounts in the Firebase Console, under the Auth tab.
      // - **weak-password**:
      //  - Thrown if the password is not strong enough.

      // send email to email_user لتحقق
      unawaited(userCredential.user!.sendEmailVerification());
      _firestore.collection("user").doc(userCredential.user!.uid ).set(userM.toMap()) ;
      return true;
    } on FirebaseAuthException catch (ex) {
      _controlException(ex, context);
    } catch (ex) {
      ex..hashCode;
      print('An error occurred\n');
    }
    return false;
  }

   // login
  Future<bool> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      // A [FirebaseAuthException] maybe thrown with the following error code:
      // - **invalid-email**:
      //  - Thrown if the email address is not valid.
      // - **user-disabled**:
      //  - Thrown if the user corresponding to the given email has been disabled.
      // - **user-not-found**:
      //  - Thrown if there is no user corresponding to the given email.
      // - **wrong-password**:
      //  - Thrown if the password is invalid for the given email, or the account
      //    corresponding to the email does not have a password set.
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // تم التحقق من الإيميل او لا
      if (userCredential.user!.emailVerified) {
        return true;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ThemeHelper()
                .alartDialog("Email_Verified", "You check Email", context);
          },
        );
      }
    } on FirebaseAuthException catch (ex) {
      _controlException(ex, context);
    } catch (ex) {
      ex..hashCode;
      print('An error occurred\n');
    }
    return false;
  }

  // Logout
  Future<bool> signOut({required BuildContext context}) async {
    try {
      await _auth.signOut();
      return true ;
    }  on FirebaseAuthException catch (ex) {
      _controlException(ex, context);
    } catch (ex) {
      ex.hashCode;
      print('An error occurred\n');
    }
    return false ;
  }

  // ChangePasswerd
  Future<bool> sendChangePasswerd(
      {required  String email, required BuildContext context}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email) ;
      return true ;
    } on FirebaseAuthException catch (ex) {
      _controlException(ex, context);
    } catch (ex) {
      ex.hashCode;
      print('An error occurred\n');
    }
    return false ;
  }

  // Fetch user data according to its passable key(uid)
  getUserGroups({required String uid, required BuildContext context}){
    try{
      return _firestore.collection('user').doc(uid).snapshots() ;
    }
    on FirebaseAuthException catch (ex) {
      _controlException(ex, context);
    } catch (ex) {
      ex.hashCode;
      print('An error occurred\n');
    }

  }

  void _controlException(
      FirebaseAuthException exception, BuildContext context) {
    exception.hashCode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          exception.message ?? '',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}