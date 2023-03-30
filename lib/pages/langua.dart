import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:domestiko/Utilities/col.dart';
class langu extends StatefulWidget {
  const langu({super.key});

  @override
  State<langu> createState() => _languState();
}

class _languState extends State<langu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: "Language settings".text.bold.white.make(),
        backgroundColor: rang.always,
        toolbarHeight: 70,
      ),

      body: Container(
        
        child: Column(
           
        ).p16(),
      ),
    );
  }
}
