import 'package:bloc/bloc.dart';
import 'package:model_chat/business_logic/events.dart';
import 'package:model_chat/business_logic/states.dart';
import 'package:model_chat/data/repostory_controller/group_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<EventAuth, ProcessState> {
  String _uid = FirebaseAuth.instance.currentUser!.uid ;
  //* Bloc <Event,State>
  //! super.initialState >> State is initial
  // ignore: avoid_types_as_parameter_names
  AuthBloc(super.initialState) {
    // on the action >> event return => emit
    //? User
    on((getSearchSnapshotEvent event, emit ) => _searchByNameBlock(event, emit));
    on((isJoinEvent event, emit) => _joinORnot(event , emit ));
  }
  //? ignore: unused_element
  //! provider >> {required String email,required String password} return user != null
  //* bolc >> Event( email , user ) >> emit(State)
  //? Button LogIn
  void _searchByNameBlock(getSearchSnapshotEvent event, Emitter<ProcessState> emit) async {
    QuerySnapshot? searchSnapshot;
    bool isLoding = true  ;
    await GFBC(uid: _uid).searchByName(groupName: event.name_group )
      .then((snapshot) {
        searchSnapshot = snapshot;
        isLoding = false ;
    });
    // ignore: unused_local_variable
    // ignore: invalid_use_of_visible_for_testing_member
    //! State =>> true if  user != null  > Found User
    emit(ProcessResult(searchSnapshot, searchSnapshot!.docs.length!=0 , isLoding ));
  }

  void _joinORnot(isJoinEvent event , Emitter<ProcessState> emit) async {
    bool join = await GFBC(uid: _uid )
      .joinORnot(
        groupID: event.groupId,
        groupName: event.groupName ,
      );
    emit(ProcessJoin(join)) ;
  }
}