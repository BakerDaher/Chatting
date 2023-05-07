import 'package:flutter/material.dart';
import 'package:model_chat/business_logic/bloc/bloc_Auth.dart';
import 'package:model_chat/business_logic/events.dart';
import 'package:model_chat/business_logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model_chat/helper/sharedPrefrences.dart';
import 'package:model_chat/presentation/widgets/joinGroup.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _search ;
  @override
  void initState() {
    _search = TextEditingController() ;
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _search.dispose() ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Search",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white ,
          ),
        ),
        iconTheme: Theme.of(context).iconTheme ,
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //height: 50,
            padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal:10),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    style: const TextStyle(color: Colors.white,fontSize: 18),
                    decoration: const InputDecoration(
                      border: InputBorder.none ,
                      hintText: "Search groups...." ,
                      hintStyle: TextStyle(
                        color: Colors.white , fontSize: 16,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if (_search.text.isNotEmpty) {
                      BlocProvider.of<AuthBloc>(context)
                          .add(getSearchSnapshotEvent(_search.text));
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<AuthBloc, ProcessState>(
            buildWhen: (previous, current) => current is ProcessResult ,
            builder: (context, state){
              if(state is ProcessResult){
                if ( state.isLoding ) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor ,
                    ),
                  );
                }
                else {
                  if (state.found) {
                    return SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: state.searchSnapshot!.docs.length ,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          return JoinGroup(
                            groupName: state.searchSnapshot!.docs[index]['groupName'],
                            groupId: state.searchSnapshot!.docs[index]['groupId'],
                            userName: SharedPref().FName + " " + SharedPref().LName ,
                            admin: state.searchSnapshot!.docs[index]['admin'] ,
                          );
                        }
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Text(
                        "You has not User Searched any groups...",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),
                      ) ,
                    );
                  }
                }
              }else{
                return Text("By MySearch") ;
              }
            } ,
          ) ,
        ],
      ),
    );
  }
}