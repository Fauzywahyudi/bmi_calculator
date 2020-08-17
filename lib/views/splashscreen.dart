import 'dart:async';

import 'package:calculator_bmi/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String _dirImage = "assets/images/";
  styleBMI(Color color){
    return GoogleFonts.mcLaren(color: color, fontSize: 40);
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), ()=>Navigator.pushReplacementNamed(context, Home.routeName) );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20,),
              Container(
                height: Orientation == Orientation.landscape ? MediaQuery.of(context).size.height * 0.4 :MediaQuery.of(context).size.height * 0.6,
                  child: SvgPicture.asset(_dirImage+"man.svg",color: Colors.white,)),
              SizedBox(height: 20,),
              RichText(
                text: TextSpan(
                  text: '',
                  style: GoogleFonts.comicNeue(),
                  children: <TextSpan>[
                    TextSpan(text: 'B', style: styleBMI(Colors.lightBlue)),
                    TextSpan(text: 'M', style: styleBMI(Colors.lightGreen)),
                    TextSpan(text: 'I ', style: styleBMI(Colors.pink ) ),
                    TextSpan(text: 'Calculator', style: GoogleFonts.mcLaren(fontSize: 25)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
