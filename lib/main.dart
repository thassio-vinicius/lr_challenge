import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lr_challenge/UI/splash_screen.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/hexcolor.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    theme: ThemeData(
        textTheme: TextTheme(
          headline1: GoogleFonts.inter(color: HexColor('#32315C'), fontSize: Adapt.px(18)),
          headline2: GoogleFonts.inter(color: HexColor('#32315C'), fontSize: Adapt.px(26), fontWeight: FontWeight.bold),
        ),
        primaryColor: HexColor('32315C')),
  ));
}

class ReNest extends StatelessWidget {
  const ReNest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'hello fuck',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
