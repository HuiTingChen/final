import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/views/profilescreen.dart';
import 'package:mytutor/views/subjectscreen.dart';
import 'package:mytutor/views/subscribescreen.dart';
import 'package:mytutor/views/tutorscreen.dart';

import '../models/user.dart';
import 'favouritescreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  int currentIndex = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }
    final items = [
      const Icon(Icons.subject_outlined, size: 30),
      const Icon(Icons.person_search, size: 30),
      const Icon(Icons.ads_click_outlined, size: 30),
      const Icon(Icons.favorite_rounded, size: 30),
      const Icon(Icons.person, size: 30),
    ];
    return Scaffold(
        body: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: [
              SubjectScreen(user: widget.user),
              TutorScreen(user: widget.user),
              SubscribeScreen(user: widget.user),
              FavouriteScreen(user: widget.user),
              ProfileScreen(user: widget.user)
            ]),
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
            buttonBackgroundColor: const Color.fromARGB(255, 18, 69, 64),
            backgroundColor: Colors.transparent,
            height: 50,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            index: currentIndex,
            items: items,
            onTap: (index) {
              controller.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            color: Colors.teal,
          ),
        ));
  }
}
