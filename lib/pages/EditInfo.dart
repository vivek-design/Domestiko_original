
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class Editinfo extends StatefulWidget {
  const Editinfo({super.key});

  @override
  State<Editinfo> createState() => _EditinfoState();
}

// Future pickImage() async {
//   try {
//     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (image == null) {
//       return;
//     }

//     final imageTemporary = File(image.path as List<Object>);
//     this.image = imageTemporary;
//   } on PlatformException catch (e) {
//     print('failed to pick image $e');
//   }
// }

class _EditinfoState extends State<Editinfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
                child: Column(
          children: [
            Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill),
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
                      right: 210,
                      top: 200,
                      width: 130,
                      height: 200,
                      child: Container(
                          child: (CircleAvatar(
                        radius: 58,
                        backgroundImage: AssetImage(
                            'assets/images/WhatsApp Image 2022-06-16 at 12.03.50 PM (1).jpeg'),
                        child: Stack(children: [
                          Positioned(
                            top: 120,
                            left: 90,
                            child: Container(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white70,
                                  child: Icon(CupertinoIcons.camera),
                                ),
                                onTap: () {
                                  // pickImage();
                                },
                              ),
                            ),
                          ),
                        ]),
                      )))),
                ],
              ),
            ),
            Container(
              //all the remaining profile options

              child: Column(children: <Widget>[
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
                            // controller: _email,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "    Email ",
                                hintStyle: TextStyle(color: Colors.grey[400])),
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
                            // controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "  Password",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value != null) if (value.isEmpty) {
                                return "password connot be null";
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ],
        ))));
  }
}
