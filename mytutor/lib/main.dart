import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/views/mainscreen.dart';

import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tutor',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color.fromARGB(255, 246, 254, 255),
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          )),
      home: const MySplashScreen(title: 'My Tutor'),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool remember = false;
  String status = "Loading...";
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();

    User user = User(
        id: '0',
        name: 'guest',
        email: 'guest@gmail.com',
        datereg: '0',
        cart: '0');

    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user))));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(0, 48, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: Image.asset('assets/images/logo.png', scale: 1.5),
                  ),
                  const Text(
                    "My Tutor APP",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              const CircularProgressIndicator(),
              Column(
                children: const [
                  Text("Version 0.1",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
