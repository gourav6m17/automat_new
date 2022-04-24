import 'dart:developer';

import 'package:automat/Constant/const.dart';
import 'package:automat/testfile.dart';
import 'package:automat/ui/basic/home.dart';
import 'package:automat/ui/basic/language_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  request() async {
    await Permission.location.request();
    await Permission.bluetooth.request().then((value) => log(value.name));
  }

  @override
  void initState() {
    super.initState();
    request();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Home(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/bg.png"))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
                child: Image.asset(
              automatLogo,
              fit: BoxFit.contain,
              height: height * 0.4,
              width: width,
            )),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Center(
              child: Image.asset(
            turboLogo,
            fit: BoxFit.contain,
            height: height * 0.1,
            width: width,
          )),
        ],
      ),
    ));
  }
}
