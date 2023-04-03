import 'package:domestiko/Utilities/Routes.dart';
import 'package:domestiko/auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../Utilities/settingtile.dart';

class setting_page extends StatefulWidget {
  const setting_page({super.key});

  @override
  State<setting_page> createState() => _setting_pageState();
}

class _setting_pageState extends State<setting_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              SettingsTile(
                color: Colors.blue,
                icon: Ionicons.person_circle_outline,
                title: "Account",
                onTap: () {
                  Navigator.popAndPushNamed(context, router.profile);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SettingsTile(
                color: Colors.green,
                icon: Ionicons.pencil_outline,
                title: "Edit Information",
                onTap: () {
                  Navigator.pushNamed(context, router.editinfo);
                
                },
              ),
              const SizedBox(
                height: 40,
              ),
              // SettingsTile(
              //   color: Colors.black,
              //   icon: Ionicons.moon_outline,
              //   title: "Theme",
              //   onTap: () {},
              // ),
              const SizedBox(
                height: 10,
              ),
              SettingsTile(
                color: Colors.purple,
                icon: Ionicons.language_outline,
                title: "Language",
                onTap: () {
                  Navigator.pushNamed(context, router.verify);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SettingsTile(
                color: Colors.red,
                icon: Ionicons.log_out_outline,
                title: "Logout",
                onTap: () {
                  
                  Auth().signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      router.loginroute, (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
