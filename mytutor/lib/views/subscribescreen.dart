import 'package:flutter/material.dart';

import '../models/user.dart';

class SubscribeScreen extends StatefulWidget {
  final User user;
  const SubscribeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Subscribe'),
      ),
        body: Center(
          child: Container(
            child: Text('Subscribe'),
          ),
        ),
    );
  }
}