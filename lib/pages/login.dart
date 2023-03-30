
import 'package:domestiko/auth.dart';
import 'package:domestiko/pages/alertbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:domestiko/Utilities/Routes.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  displaytoast(String s, BuildContext context) {
    Fluttertoast.showToast(msg: s);
  }

  // get Firebase => null;
  @override
  //this function is used to initialize all the late variable and it will be call by the flutter automatically
  //this two functions are only called in statefull widgets

  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  // dispose method used to release the memory allocated to variables when state object is removed. For example, if you are using a stream in your
  // application then you have to release memory allocated to the stream controller. Otherwise, your app may get a warning from the PlayStore and AppStore about memory
  // leakage
  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      "Login",
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
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, 1),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(),
                          child: TextFormField(
                              controller: _email,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "    Email ",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              validator: (value) {
                                if (value != null) if (value.isEmpty) {
                                  return "Email or phone number cannot be empty ";
                                }
                                return null;
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(),
                          child: TextFormField(
                              controller: _password,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "  Password",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              validator: (value) {
                                if (value != null) if (value.isEmpty) {
                                  return "password connot be null";
                                }
                                return null;
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      //this process returns the future so withput the use of await keywoed it will return the instance of future
                      //   on hitting the login button if there is no such user than the firebase  throw an exception so to interact with this
                      //problem then we will use exception handling

                      try {
                        if (_email.text.length == 0) {
                          displaytoast("Email field can't be empty", context);
                          setState(() {});
                        }
                        if (_password.text.length == 0) {
                          displaytoast(
                              "password field can't be empty", context);
                          setState(() {});
                        }

                      
                        await Auth().signInWithEmailAndPassword(
                            email: _email.text, password: _password.text);

                        final user = Auth().currentUser;
                        if (user?.emailVerified ?? false) {
                            DatabaseReference databaseRefu = FirebaseDatabase.instance.ref('User');
                             
                           databaseRefu.child(user!.uid).once().then((Event){
                            final dataSnapshot = Event.snapshot.exists;
                            if(dataSnapshot){
                                   displaytoast("loggin in ", context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              router.center, (route) => false);
                                
                                     
                            }else{
                                  displaytoast("loggin in ", context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              router.maid, (route) => false); 
                              
                            }
                         
                           });
                        
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              router.verify, (route) => false);
                          // log(usercredential.toString());
                        }
                      } on FirebaseAuthException catch (e) {
                        // await showErrorDialog(context, e.toString());

                        if (e.code == 'user-not-found') {
                          showErrorDialog(context, "    User not found");
                          setState(() {});
                        } else if (e.code == 'wrong-password') {
                          showErrorDialog(context, "   Wrong Password");
                          setState(() {});
                        } else if (e.code == 'invalid-email') {

                          showErrorDialog(context, "   Invalid Email");
                          setState(() {});
                        } else {
                          showErrorDialog(context, e.toString());
                          setState(() {});
                        }
                      }
                    },
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
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          await showErrorDialog(
                              context, "Password reset mail has sent ");

                          await Auth()
                              .sendPasswordResetEmail(email: _email.text);
                        },
                        child: Text("Forgot password?",
                            style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
