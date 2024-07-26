import 'package:flutter/material.dart';
import 'package:sabroso/modules/user_auth/screens/login_screen.dart';
import 'package:sabroso/modules/user_auth/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WelcomePage()), (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Sabroso",
          style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
