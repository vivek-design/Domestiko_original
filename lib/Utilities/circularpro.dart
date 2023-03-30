import 'package:domestiko/Utilities/col.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class circularindi extends StatelessWidget {
  const circularindi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
      
              child: Lottie.network(
                "https://assets2.lottiefiles.com/private_files/lf30_ixykrp0i.json",
                repeat: true,
                height: 100,
                width: 100,
                
              )
      ),
    );
  }
}