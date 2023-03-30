import 'package:domestiko/auth.dart';
import 'package:domestiko/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:domestiko/Utilities/Routes.dart';
import 'package:domestiko/Utilities/col.dart';

class emailverified extends StatefulWidget {
  const emailverified({Key? key}) : super(key: key);

  @override
  State<emailverified> createState() => _emailverifiedState();
}

class _emailverifiedState extends State<emailverified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Container(
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 30,
                width: 80,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/light-1.png'),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 140,
                width: 80,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/light-2.png'),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 40,
                top: 40,
                width: 80,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/clock.png'),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 225,
                  left: 100,
                  child: Container(
                    child: Center(
                        child: Text(
                      "verification",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    )),
                  )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Text(
            "We have sent you an email verification on your registered mail ",
            style: TextStyle(
              fontSize: 15,

              fontWeight: FontWeight.bold,
              // fontStyle: FontStyle.normal,
              color:Colors.black,
              
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.all(20),
          child: Text(
            "If not received ",
            style: TextStyle(
              fontSize: 15,
             
              fontWeight: FontWeight.bold,
              // fontStyle: FontStyle.normal,
              color:Colors.black,
            ),
          ),
        ),

        SizedBox(
          height: 15,
        ),

        // const Text('If you have not received press the button below '),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(rang.always),
          ),
          onPressed: () async {
            await Auth().sendEmailverifiacation();
            final User? user = Auth().currentUser;

            if (user?.emailVerified ?? false) {
              login_page();
            }
          },

          //in the curent code base we are just authenticating user with email and password
          //in this codebase we are communicating with the firebase to the ui with the same mixed
          //code but there are some authetications providers like google microsoft apple acount which
          //lets user to login and sign out then there will be a layer between the ui and  firebase

          //it provides authentication and communicate with the firebase directly we dont need to specify seperaterly
          //now there is one layer between ui and  firebase
          child: const Text('send email verification '),
        ),
        SizedBox(
          height: 10,
        ),

        // const Text('If you have not received press the button below '),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(rang.always),
          ),
          onPressed: () async  {
             await Auth().signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, router.registerr, (route) => false);
          },

          //in the curent code base we are just authenticating user with email and password
          //in this codebase we are communicating with the firebase to the ui with the same mixed
          //code but there are some authetications providers like google microsoft apple acount which
          //lets user to login and sign out then there will be a layer between the ui and  firebase

          //it provides authentication and communicate with the firebase directly we dont need to specify seperaterly
          //now there is one layer between ui and  firebase
          child: const Text('Reset '),
        ),
      ]),
    ));
  }
}
