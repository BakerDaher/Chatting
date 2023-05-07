import 'package:flutter/material.dart';
import 'package:model_chat/constant/Strings/strings.dart';
import 'package:model_chat/data/repostory_controller/firbase_controller.dart';
import 'package:model_chat/data/repostory_controller/group_controller.dart';
import 'package:model_chat/helper/sharedPrefrences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:model_chat/presentation/widgets/GroupTile.dart';
import 'package:model_chat/presentation/widgets/text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  late TextEditingController _name_group;
  final _formKey = GlobalKey<FormState>() ;

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    _name_group = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _name_group.dispose();
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
        title: Center(
          child: const Text(
            "Groupes",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        elevation: 0.5,
        iconTheme: Theme.of(context).iconTheme ,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchPage);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        width: 250,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.3),
                Theme.of(context).accentColor.withOpacity(0.6),
              ],
            ),
          ),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.5),
                      Theme.of(context).accentColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          maxRadius: 30,
                          child: Icon(
                            Icons.person,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        SharedPref().FName + " " + SharedPref().LName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        SharedPref().Email,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  size: 24,
                  color: Colors.black,
                ),
                title: const Text(
                  "Groups",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.nights_stay,
                  size: 24,
                  color: Colors.black,
                ),
                title: const Text(
                  "Night",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.language,
                  size: 24,
                  color: Colors.black,
                ),
                title: const Text(
                  "Language",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                onTap: () {},
                trailing: Text("AR"),
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  size: 24,
                  color: Colors.black,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure want to Logout?"),
                        actions: [
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black38)),
                            onPressed: () async {
                              bool Register = await FBController().signOut(context: context) ;
                              if(Register){
                                SharedPref().clear();
                                Navigator.pushReplacementNamed(
                                    context, loginScreen);
                              }
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black38)),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  groupList() {
    return StreamBuilder(
      // Fetch Documentation in Current_user
      stream: FBController().getUserGroups(
          uid: FirebaseAuth.instance.currentUser!.uid, context: context),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex =
                      snapshot.data!['groups'].length - index - 1;
                  return groupTile(
                    groupId: getId(snapshot.data['groups'][reverseIndex]),
                    groupName: getName(snapshot.data['groups'][reverseIndex]),
                    userName:  SharedPref().FName + " " + SharedPref().LName ,
                  );
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  // Add New Groups Same """"FloatingActionButton""""
  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Butten
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  // Greate new Groups
  void popUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Form(
              key: _formKey,
              child: AlertDialog(
                title: const Text(
                  "Create a group",
                  textAlign: TextAlign.left,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isLoading == true ?
                    Center(
                      child: CircularProgressIndicator(
                          color: Theme
                              .of(context)
                              .primaryColor),
                    ) :
                    text_Field(
                      hintText: "Group of name",
                      labelText: "Enter your name",
                      type: TextInputType.name,
                      function: (val) {
                        if (val!.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                      text: _name_group,
                    ),
                  ],
                ),
                actions: [
                  // Cancele
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme
                            .of(context)
                            .primaryColor)
                    ),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // Greate
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme
                          .of(context)
                          .primaryColor),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        // Greate Groups
                        String id = await GFBC(uid: FirebaseAuth.instance.currentUser!.uid)
                            .greategroups(
                          groupName: _name_group.text,
                          userName: (SharedPref().FName + " " +
                              SharedPref().LName),
                        )
                            .whenComplete(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Group created successfully.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme
                                      .of(context)
                                      .accentColor),
                            ),
                            duration: Duration(seconds:2),
                            action: SnackBarAction(
                              onPressed: () async {
                                // Delete Group
                                await GFBC(uid: FirebaseAuth.instance.currentUser!.uid).deleteGroups(id_group: id , groupName: _name_group.text) ;
                              },
                              label: "Cancel",
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "CREATE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ) ;
          } ,
        );
      },
    );
  }
}