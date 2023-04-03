import 'package:domestiko/Utilities/UserModel.dart';
import 'package:domestiko/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:domestiko/Utilities/col.dart';

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
  var selectedRadio;
  var selectedGen;
  String Gender = "";
  @override
  void initState() {
    super.initState();
    if (Userdet.gender == "Male") {
      selectedRadio = 0;
      selectedGen = 0;
    } else {
      selectedRadio = 1;
      selectedGen = 1;
    }
  }

  void setSelectedRadioRegiste(Object? val) {
    setState(() {
      selectedRadio = val;
    });
  }

  void setgenRadio(Object? vale) {
    setState(() {
      selectedGen = vale;
    });
  }

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
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Color.fromRGBO(143, 148, 251, 1),
                    //       blurRadius: 20.0,
                    //       offset: Offset(0, 10))
                    // ]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      "  Username".text.bold.make(),
                      10.heightBox,
                      Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextFormField(
                            // controller: _email,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "   ${Userdet.name} ",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value != null) if (value.isEmpty) {
                                return "Email or phone number cannot be empty ";
                              }
                              return null;
                            }),
                      ),
                      20.heightBox,
                      "  Age".text.bold.make(),
                      10.heightBox,
                      Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextFormField(
                            // controller: _email,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: " ${Userdet.age} ",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value != null) if (value.isEmpty) {
                                return "Email or phone number cannot be empty ";
                              }
                              return null;
                            }),
                      ),
                      20.heightBox,
                      " Gender".text.bold.make(),
                      10.heightBox,
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Text("Gender :"),
                            Radio(
                                value: 4,
                                activeColor: rang.always,
                                groupValue: selectedGen,
                                onChanged: (vale) {
                                  Gender = "Male";
                                  setgenRadio(vale);
                                }),
                            Text("Male"),
                            SizedBox(
                              width: 30,
                            ),
                            Radio(
                                value: 3,
                                activeColor: rang.always,
                                groupValue: selectedGen,
                                onChanged: (vale) {
                                  Gender = "Female";
                                  setgenRadio(vale);
                                }),
                            Text("Female"),
                          ],
                        ),
                      ),
                      20.heightBox,
                      "  Phone".text.bold.make(),
                      10.heightBox,
                      Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextFormField(
                            // controller: _email,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: " ${Userdet.age} ",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                            validator: (value) {
                              if (value != null) if (value.isEmpty) {
                                return "Email or phone number cannot be empty ";
                              }
                              return null;
                            }),
                      ),
                      40.heightBox,
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, 6),
                              ])),
                          child: Center(
                            child: Text("update",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ),
                        ),
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
