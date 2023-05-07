import 'package:flutter/material.dart';
import 'package:model_chat/data/repostory_controller/group_controller.dart';
import 'package:model_chat/presentation/Screen/group_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:model_chat/presentation/widgets/MessageTile.dart';
import 'package:model_chat/presentation/widgets/text_field.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const ChatPage(
    {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
    : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admain = "" ;
  late TextEditingController _massege ;

  @override
  void initState() {
    _massege = TextEditingController() ;
    GFBC(uid: FirebaseAuth.instance.currentUser!.uid).getGroupAdmain(group_Id: widget.groupId).then((val) {
      setState((){
        admain = val ;
      });
    }
    ) ;
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _massege.dispose() ;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.groupName,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold )),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).iconTheme ,
        actions:[
          IconButton(
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                  GroupInfo(
                    groupName: widget.groupName,
                    groupId: widget.groupId,
                    admainName: admain,
                    userName:  widget.userName,
                  ),
                ),
              );
            },
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        children: [
          chatMessages() ,
          Container(
            color: Colors.red,
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[500],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: text_Field(
                      type: TextInputType.text,
                      text: _massege,
                      hintText: "Send a message...",
                      labelText: "message",
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  chatMessages() {
    return Expanded(
      child: StreamBuilder(
        stream: GFBC(uid: FirebaseAuth.instance.currentUser!.uid).getChats(
          group_Id: widget.groupId ,
        ),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe: widget.userName ==
                        snapshot.data.docs[index]['sender']);
              },
            );
          } else {
            return Container();
          }
        }
      ),
    );
  }

  void sendMessage() {
    if(_massege.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        "message": _massege.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      GFBC(uid: FirebaseAuth.instance.currentUser!.uid).sendMessage(
        groupId: widget.groupId , chatMessageData: chatMessageMap ,
      );
      _massege.clear();
    }
  }
}
