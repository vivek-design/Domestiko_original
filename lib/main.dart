import 'dart:math';

import 'package:domestiko/Notification/jobdialog.dart';
import 'package:domestiko/Utilities/circularpro.dart';
import 'package:domestiko/Utilities/language.dart';
import 'package:domestiko/Utilities/nomaidavailable.dart';
import 'package:domestiko/Utilities/retriveorderdetail.dart';
import 'package:domestiko/auth.dart';
import 'package:domestiko/pages/AcceptedPage.dart';
import 'package:domestiko/pages/EditInfo.dart';
import 'package:domestiko/pages/EmailaVerification.dart';
import 'package:domestiko/pages/accepted_foruser.dart';
import 'package:domestiko/pages/centerpage.dart';
import 'package:domestiko/pages/contact.dart';
import 'package:domestiko/pages/gettingstart.dart';
import 'package:domestiko/pages/history.dart';
import 'package:domestiko/pages/langua.dart';
import 'package:domestiko/pages/login.dart';
import 'package:domestiko/pages/maidpage.dart';
import 'package:domestiko/pages/profile.dart';
import 'package:domestiko/pages/register2.dart';
import 'package:domestiko/pages/reigister.dart';
import 'package:domestiko/pages/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:domestiko/Utilities/Routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'firebase_options.dart';

bool value = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // data();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: router.homepage,

      routes: {
        router.registerr2: (context) => registermaid(),
        router.Setting: (context) => setting_page(),
        router.getting: (context) => gettingstarted(),
        router.History: (context) => History_page(),
        router.profile: (context) => Profile(),
        router.loginroute: (context) => login_page(),
        router.first: (context) => home(),
        router.homepage: (context) => HomePage(),
        router.registerr: (context) => registerview(),
        router.verify: (context) => emailverified(),
        router.center: (context) => Central(),
        router.contact: (context) => contactus(),
     
        router.maid: (context) => maidpage(),
        router.Nomaidavail: (context) => NomaidAvailableDialog(),
        router.langua:(context)=>langu(),
        router.editinfo:(context)=>Editinfo(),

        // accepted_page.(router.acceptedpage): (context) =>
        //       accepted_page(Readme: mm ,),

        // router.jobdialog: (context) => job_dialog()
      },

      debugShowCheckedModeBanner: false,
      // supportedLocales: ln10.all,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  @override
  var value;
  Future<bool> data() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }
    DatabaseReference databaseRefu = FirebaseDatabase.instance.ref('User');
    var dataSnapshot;
    await databaseRefu.child(user!.uid).once().then((Event) {
      dataSnapshot = Event.snapshot.exists;
    });

    if (dataSnapshot == null) {
      value = false;
      return false;
    }
    value = true;
    return true;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   data();
  //   Future.delayed(Duration(seconds: 5));
  //   print("init");
  // }

  Widget build(BuildContext context) {
    //scaffold class for structure building in flutter
    displaytoast(String s, BuildContext context) {
      Fluttertoast.showToast(msg: s);
    }

    return FutureBuilder(
        future: data(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            User? user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return home();
            }

            if (user.emailVerified == false) {
              print(Auth().currentUser);

              return emailverified();
            }
            if (value == true) {
              return Central();
            }

            return maidpage();
          } else {
            return circularindi();
          }
        });

    //   //here we are gonna return all the the views that we have created for the register view
    //   // User? user = FirebaseAuth.instance.currentUser;

    //   if (value == true) {
    //     return Central();
    //   }

    //   return maidpage();
    // }

    // Future<Widget> fun(BuildContext context) async{
    //   User? user = FirebaseAuth.instance.currentUser;
    //   DatabaseReference databaseRefu = FirebaseDatabase.instance.ref('User');
    //   var dataSnapshot;
    //  await databaseRefu.child(user!.uid).once().then((Event) {
    //     dataSnapshot = Event.snapshot.exists;
    //   });
    //   Future.delayed(Duration(seconds: 2));

    //   if (dataSnapshot != null) {
    //     return centered();
    //   }

    //   return maidpage();
    // }
  }
}

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        child: Container(
                      child: Center(
                          child: Text(
                        "Welcome",
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
              SizedBox(
                height: 30,
              ),
              Container(
                child: Center(
                  child: Text("Don't have an account ? Have one ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(143, 148, 251, 1),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () => {Navigator.pushNamed(context, router.getting)},
                  child: Ink(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, 6),
                        ])),
                    child: Center(
                      child: Text("Create account ",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: Center(
                  child: Text("Already have an account ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(143, 148, 251, 1),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  child: InkWell(
                    onTap: () =>
                        {Navigator.pushNamed(context, router.loginroute)},
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, 6),
                          ])),
                      child: Center(
                        child: Text("Login",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
