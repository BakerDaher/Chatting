import 'package:cloud_firestore/cloud_firestore.dart';
// Group Fire Base Controller
class GFBC{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _uid ;

  GFBC({required String uid}){
    this._uid = uid ;
  }

  // Greate Groupes
  Future<String> greategroups({required String groupName , required String userName}) async {
    DocumentReference groupDocumentReference = await _firestore.collection("groups").add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${_uid}_$userName" ,
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      // add Admain to members whith members
      // key > user ,,,, name > user
      "members": FieldValue.arrayUnion(["${_uid}_$userName"]),
      // add Id from Groups
      "groupId": groupDocumentReference.id,
    });

    await _firestore.collection("user").doc(_uid).update({
      // key > group ,,,, name > group
      "groups":
      FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"]) ,
    });
    return groupDocumentReference.id ;
  }

  //Delete Groups all befor add any person
  Future deleteGroups({required String id_group , required String groupName})async{
    await _firestore.collection("groups").doc(id_group).delete() ;
    await _firestore.collection("user").doc(_uid).update({
      "groups": FieldValue.arrayRemove(["${id_group}_$groupName"]) ,
    });
  }

  getMembers({required String group_Id}){
    return  _firestore.collection("groups").doc(group_Id).snapshots() ;
  }

  // getting the chats
  getChats({required String group_Id}){
    return  _firestore.collection("groups").doc(group_Id)
      .collection("messages")
      .orderBy("time")
      .snapshots() ;
  }

  // Send Massege
  sendMessage({required String groupId,required Map<String, dynamic> chatMessageData}) async {
    _firestore.collection("groups").doc(groupId).collection("messages").add(
        chatMessageData);
    _firestore.collection("groups").doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  // get Admain name and Id_admain
  Future getGroupAdmain({required String group_Id}) async{
    DocumentSnapshot documentSnapshot =  await _firestore.collection("groups").doc(group_Id).get();
    return documentSnapshot["admin"] ;
  }

  Future searchByName({required String groupName}) async {
    try{
      return _firestore.collection("groups").where("groupName", isEqualTo: groupName).get() ;
    }
    on FirebaseFirestore catch (ex) {
      _controlException(ex);
    } catch (ex) {
      ex.hashCode;
      print('An error occurred\n');
    }
  }

  Future<bool> joinORnot({required String groupID , required String groupName})async {
    try{
      DocumentReference userDocumentReference = _firestore.collection('user').doc(_uid);
      DocumentSnapshot documentSnapshot = await userDocumentReference.get();

      List<dynamic> groups = await documentSnapshot['groups'];
      bool join = groups.contains("${groupID}_${groupName}") ;
      if(join){
        return true ;
      }
    }on FirebaseFirestore catch (ex) {
      _controlException(ex);
    } catch (ex){
      ex.hashCode;
      print('An error occurred\n');
    }
    return false ;
  }

  // join
  Future<void> join({ required String groupId , required String groupName , required String userName})async {
    try{
      await _firestore.collection("user").doc(_uid).update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await _firestore.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayUnion(["${_uid}_$userName"])
      });
    }on FirebaseFirestore catch (ex) {
      _controlException(ex);
    } catch (ex){
      ex.hashCode;
      print('An error occurred\n');
    }
  }

  // log out
  Future<void> joinded({required String groupId , required String groupName , required String userName}) async {
    try{
      await _firestore.collection("user").doc(_uid).update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await _firestore.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayRemove(["${_uid}_$userName"])
      });
    }on FirebaseFirestore catch (ex) {
      _controlException(ex);
    } catch (ex){
      ex.hashCode;
      print('An error occurred\n');
    }
  }

  void _controlException(FirebaseFirestore exception) {
    print(exception.hashCode) ;
  }

}