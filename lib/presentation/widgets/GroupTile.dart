import 'package:flutter/material.dart';
import 'package:model_chat/data/repostory_controller/group_controller.dart';
import 'package:model_chat/helper/Helper.dart';
import 'package:model_chat/presentation/Screen/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class groupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const groupTile(
      {Key? key,
        required this.groupId,
        required this.groupName,
        required this.userName})
      : super(key: key);

  @override
  State<groupTile> createState() => _groupTileState();
}

class _groupTileState extends State<groupTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ListTile(
        onTap: (){
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
        },
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            widget.groupName.substring(0, 1).toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        title: Text(
          widget.groupName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Join the conversation as ${widget.userName}",
          style: const TextStyle(fontSize: 13),
        ),
        // Same the Icons.more_vert
        trailing: PopupMenuButton<int>(
          itemBuilder: (context) => [
            // PopupMenuItem 1
            PopupMenuItem(
              value: 1,
              // row with 2 children
              child: Row(
                children: const [
                  Icon(Icons.logout) ,
                  SizedBox(
                    width: 8,
                  ),
                  Text("LogOut"),
                ],
              ),
            ),
          ],
          offset: const Offset(-22, 32),
          color: Colors.grey,
          elevation: 2,
          // on selected we show the dialog box
          onSelected: (value) {
            // if value 1 show dialog
            if (value == 1) {
              _showDialog(
                context: context ,
                subTile: "Sign out of the group",
                Tile: "LogOut" ,
                function: (){
                  GFBC(uid: FirebaseAuth.instance.currentUser!.uid ).joinded(
                    groupId: widget.groupId ,
                    groupName: widget.groupName,
                    userName: widget.userName ,
                  ) ;
                  ThemeHelper().showSnackbar(context, "Log_Out the group ${widget.groupName}");
                  Navigator.pop(context) ;
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _showDialog({required BuildContext context, required String Tile,required String subTile , required function }){
    showDialog(
      context: context ,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Tile),
          content: Text(subTile),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.black38)
              ),
              onPressed: function ,
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}