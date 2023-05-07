import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model_chat/business_logic/bloc/bloc_Auth.dart';
import 'package:model_chat/business_logic/events.dart';
import 'package:model_chat/business_logic/states.dart';
import 'package:model_chat/data/repostory_controller/group_controller.dart';
import 'package:model_chat/helper/Helper.dart';
import 'package:model_chat/presentation/Screen/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinGroup extends StatefulWidget {
  String userName;
  String groupId;
  String groupName;
  String admin;

  JoinGroup(
      {required this.groupName,
      required this.groupId,
      required this.userName,
      required this.admin,
      Key? key})
      : super(key: key);

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context)
      .add(isJoinEvent(widget.groupName , widget.groupId ));
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          widget.groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(widget.groupName,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin: ${getName(widget.admin)}"),
      trailing: BlocBuilder<AuthBloc, ProcessState>(
        buildWhen: (previous, current) => current is ProcessJoin ,
        builder: (context, state){
          if (state is ProcessJoin) {
            return state.isJoin
              ?ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  maximumSize: MaterialStateProperty.all(Size(200, 55)),
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Joined",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: (){
                  // left
                  GFBC(uid: FirebaseAuth.instance.currentUser!.uid ).joinded(
                    groupId: widget.groupId ,
                    groupName: widget.groupName,
                    userName: widget.userName ,
                  ) ;
                  ThemeHelper().showSnackbar(context, "Left the group ${widget.groupName}");
                  BlocProvider.of<AuthBloc>(context)
                      .add(getSearchSnapshotEvent(widget.groupName));
                },
              )
              :ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  maximumSize: MaterialStateProperty.all(Size(200, 55)),
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Join Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: (){
                  // join
                  GFBC(uid: FirebaseAuth.instance.currentUser!.uid ).join(
                    groupId: widget.groupId ,
                    groupName: widget.groupName,
                    userName: widget.userName ,
                  ) ;
                  ThemeHelper().showSnackbar(context, "Successfully joined he group");
                  BlocProvider.of<AuthBloc>(context)
                      .add(getSearchSnapshotEvent(widget.groupName));
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_)=>
                          ChatPage(
                              groupId:   widget.groupId,
                              groupName: widget.groupName,
                              userName:  widget.userName
                          ),
                      ),
                    );
                  });

                } ,
              )
            ;
          }
          return Text("") ;
        },
      ),
    );
  }
}