import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProcessState {}

// can find in any another Class
//! user
class ProcessResult extends ProcessState {
  QuerySnapshot? searchSnapshot;
  bool isLoding = true ;
  bool found = false ;
  ProcessResult(this.searchSnapshot,this.found , this.isLoding );
}

class ProcessJoin extends ProcessState {
  bool isJoin ;
  ProcessJoin(this.isJoin );
}

// ignore: camel_case_types
class initialState extends ProcessState {}