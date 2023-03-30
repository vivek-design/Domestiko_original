import 'package:contactus/contactus.dart';
import 'package:domestiko/Utilities/col.dart';
import 'package:flutter/material.dart';


    
class contactus extends StatefulWidget {
  const contactus({super.key});

  @override
  State<contactus> createState() => _contactusState();
}

class _contactusState extends State<contactus> {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ContactUs(
          logo: AssetImage('assets/images/WhatsApp Image 2022-06-16 at 12.03.50 PM (1).jpeg'),
          email: 'vivekchouhan20680@gmail.com',
          companyName: 'Domestico',
          phoneNumber: '+917067640715',
          dividerThickness: 2,
          website: 'https://abhishekdoshi.godaddysites.com',
       
          linkedinURL: 'https://www.linkedin.com/in/vivek-chouhan-16162a1b9/',
          tagLine: 'Contact',
          twitterHandle: 'Vivek chouhan', 
          cardColor: rang.always,
          taglineColor:Colors.black, 
          companyColor: rang.always, 
          textColor: Colors.black,
          
        ),
      ),
    );
  }

  }
