
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void>showErrorDialog(BuildContext context,
String text,) {
  return showDialog<void>(context: context, builder: (context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(6),
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Alert!!'),
      content: Text(text),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        },
          child: const Text('OK'),
        ),
      ],

    );
  }
  );
}