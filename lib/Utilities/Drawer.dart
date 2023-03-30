import 'package:domestiko/Utilities/Routes.dart';
import 'package:domestiko/Utilities/col.dart';
import 'package:domestiko/auth.dart';
import 'package:domestiko/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class myDrawer extends StatelessWidget {
  const myDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: rang.always,
        child: ListView(
          children: [
            DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: rang.always),
                    margin: EdgeInsets.zero,
                    accountName: Text("vaibhav chouhan",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    accountEmail: Text("vaibhavchouhan2003@gmail.com",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    currentAccountPicture: CircleAvatar(
                      // in place of image.assets we can have NetworkImage(url of image);
                      // if you want to add it from the internet then it will be the best way
                      //while using circular avatar when inserting image with background image functionality
                      // use asset image for image inserting from assets and network image for network

                      backgroundImage: AssetImage('assets/images/clock.png'),
                    ))),

            // listtile is basically a widget which is used when you want some elment in front and also in right
            // it also provide ontap functinality then it will be better to use it instead of working with container and designing it
            //
            ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
                
              },
              title: Text(
                "Home",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),

            ListTile(
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
              ),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, router.profile);
              },
            ),

            ListTile(
              leading: Icon(
                CupertinoIcons.mail,
                color: Colors.white,
              ),
              title: Text(
                "Contact Us",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushNamed(context, router.contact);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              onTap: () {
                Auth().signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    router.loginroute, (Route<dynamic> route) => false);
              },
              title: Text(
                "Log out",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
