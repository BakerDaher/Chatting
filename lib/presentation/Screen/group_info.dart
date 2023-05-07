import 'package:flutter/material.dart';
import 'package:model_chat/data/repostory_controller/group_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:model_chat/helper/Helper.dart';
import 'package:model_chat/presentation/widgets/MembersInfo.dart';

class GroupInfo extends StatefulWidget {
  final String admainName;
  final String groupId;
  final String groupName;
  final String userName ;
  const GroupInfo(
      {Key? key,
        required this.groupId,
        required this.groupName,
        required this.admainName ,
        required this.userName ,
      })
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title:const Text("Group Info",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold )),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme:Theme.of(context).iconTheme ,
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context ,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Exit"),
                    content: Text("Are you sure you exit the group? "),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.black38)
                        ),
                        onPressed: (){
                          GFBC(uid: FirebaseAuth.instance.currentUser!.uid ).joinded(
                            groupId: widget.groupId ,
                            groupName: widget.groupName,
                            userName: widget.userName ,
                          ) ;
                          ThemeHelper().showSnackbar(context, "Log_Out the group ${widget.groupName}");
                          Navigator.pop(context) ;
                          Navigator.pop(context) ;
                          Navigator.pop(context) ;
                        } ,
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ) ,
        ],
      ),
      body: Container(
        padding:const  EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:const  EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor.withOpacity(0.2) ,
              ),
              child: MembersInfo (
                Name: "Group: ${widget.groupName}",
                Id: "Admain: ${getName(widget.admainName)}",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: StreamBuilder(
                // Fetch Documentation in Current_user
                stream: GFBC(uid: FirebaseAuth.instance.currentUser!.uid).getMembers(
                  group_Id: widget.groupId ,
                ),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['members'] != null) {
                      if (snapshot.data['members'].length != 0) {
                        return ListView.builder(
                          itemCount: snapshot.data['members'].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return MembersInfo (
                              Name: getName(snapshot.data['members'][index]),
                              Id: getId(snapshot.data['members'][index]),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("NO MEMBERS"),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text("NO MEMBERS"),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}