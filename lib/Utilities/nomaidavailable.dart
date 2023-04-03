import 'package:domestiko/Utilities/Routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:domestiko/Utilities/col.dart';

class NomaidAvailableDialog extends StatefulWidget {
  const NomaidAvailableDialog({super.key});

  @override
  State<NomaidAvailableDialog> createState() => _NomaidAvailableDialogState();
}

class _NomaidAvailableDialogState extends State<NomaidAvailableDialog> {
  @override
  void deleterequest() {
    print("IN");
    final User = FirebaseAuth.instance.currentUser;
    if (User != null) {
      DatabaseReference databaseR = FirebaseDatabase.instance.ref('Request');
      databaseR.child(User.uid);
      databaseR.remove();
    }
  }

  @override
  void initState() {
    
    deleterequest();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "No Maid is open fow work in your area",
                  style: TextStyle(
                      fontFamily: 'Brand-Bold',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Try again after some  time  ",
                  style: TextStyle(
                      fontFamily: 'Brand-Bold',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "assets/images/not-available-icon-510x512-bk9kndq5.png",
                  height: 50,
                ),
                SizedBox(
                  height: 60,
                ),
                InkWell(
                  onTap: () => {
                    
                 Navigator.pushNamedAndRemoveUntil(context, router.center, (route) => false)
                 
                  },
                  child: Container(
                    child: Text("Close"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
