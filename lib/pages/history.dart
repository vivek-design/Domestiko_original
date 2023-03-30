import 'package:domestiko/Utilities/col.dart';
import 'package:flutter/material.dart';

class History_page extends StatefulWidget {
  const History_page({super.key});

  @override
  State<History_page> createState() => _History_pageState();
}

class _History_pageState extends State<History_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: rang.always,
      toolbarHeight: 100,
      title: Text("History"),
      
      ),
      body: Container(
         padding: EdgeInsets.all(20),
        child: Text("Your recent interactions",style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );
  }
}
