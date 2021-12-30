import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lr_challenge/UI/home/home_screen.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/custom_faderoute.dart';
import 'package:lr_challenge/utils/strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;

  @override
  void initState() {
    Timer(Duration(milliseconds: 750), () {
      setState(() {
        opacity = 1;
      });
    });

    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        opacity = 0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
            opacity: opacity,
            duration: Duration(milliseconds: 750),
            onEnd: () {
              if (opacity == 0) {
                Navigator.pushReplacement(context, CustomFadeRoute(child: HomeScreen(), routeName: 'home'));
              }
            },
            child: Text(
              Strings.reNest,
              style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: Adapt.px(36)),
            )),
      ),
    );
  }
}
