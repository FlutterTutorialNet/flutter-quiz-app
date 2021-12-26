import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/SplashScreen.bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Image(
            image: AssetImage("assets/images/SplashScreen.shape.png"),
          ),
        ),
      ),
    );
  }
}
