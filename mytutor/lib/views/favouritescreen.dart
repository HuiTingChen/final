import 'package:flutter/material.dart';

import '../models/user.dart';


class FavouriteScreen extends StatefulWidget {
  final User user;

  const FavouriteScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Favourite'),
      ),
        body: Center(
          child: Container(
            child: Text('Favourite'),
          ),
        ),
    );
  }
}