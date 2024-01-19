import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  final Widget? child;
  const Splashscreen({super.key, this.child});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> widget.child!), (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome Mummy!!!",
          style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
