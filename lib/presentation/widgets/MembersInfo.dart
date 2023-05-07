import 'package:flutter/material.dart';

class MembersInfo extends StatefulWidget {
  final String Name ;
  final String Id ;
  MembersInfo({
    required this.Name,
    required this.Id ,
    Key? key}) : super(key: key);

  @override
  State<MembersInfo> createState() => _MembersInfoState();
}

class _MembersInfoState extends State<MembersInfo> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      //padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            widget.Name.substring(0, 1).toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        title: Text(
          widget.Name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.Id,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}