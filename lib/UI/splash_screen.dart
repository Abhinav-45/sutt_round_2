import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';



class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.movie_filter_outlined,
              size: 150,
            ),

          ),
          CircularProgressIndicator(
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}