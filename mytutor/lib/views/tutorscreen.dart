import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tutor.dart';
import '../models/user.dart';

class TutorScreen extends StatefulWidget {
  final User user;
  const TutorScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutor> tutorList = <Tutor>[];
  String titlecenter = "";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  int cart = 0;
  TextEditingController searchController = TextEditingController();
  String search = "";
  final double tutorHeight = 100;

  @override
  void initState() {
    super.initState();
    _loadTutors(1, search);
  }

  Future<void> _refresh() async {
    return await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
        ],
      ),
      body: tutorList.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Center(
                      child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          : LiquidPullToRefresh(
              onRefresh: _refresh,
              color: Colors.teal,
              backgroundColor: const Color.fromARGB(255, 246, 254, 255),
              animSpeedFactor: 2,
              springAnimationDurationInMilliseconds: 1000,
              showChildOpacityTransition: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Expanded(
                      child: ListView(
                          children: List.generate(tutorList.length, (index) {
                    return InkWell(
                      splashColor: const Color.fromARGB(255, 156, 219, 213),
                      onTap: () => {_loadTutorDetails(index)},
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                            elevation: 5,
                            color: const Color.fromARGB(255, 220, 243, 241),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: SizedBox(
                              width: resWidth,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: CONSTANTS.server +
                                              "/276876/mytutor/mobile/assets/tutors/" +
                                              tutorList[index]
                                                  .tutorId
                                                  .toString() +
                                              '.jpg',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                              ),
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                          width: 90,
                                          placeholder: (context, url) =>
                                              const LinearProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                tutorList[index]
                                                    .tutorName
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                  tutorList[index]
                                                      .tutorEmail
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                              alignment: const Alignment(1, -1),
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.favorite_rounded,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  print("pressed");
                                                },
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    );
                  }))),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numofpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if ((curpage - 1) == index) {
                          color = const Color.fromARGB(255, 1, 30, 27);
                        } else {
                          color = const Color.fromARGB(255, 61, 174, 163);
                        }
                        return SizedBox(
                          width: 40,
                          child: TextButton(
                              onPressed: () => {_loadTutors(index + 1, "")},
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color),
                              )),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
    );
  }

  void _loadTutors(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/276876/mytutor/mobile/php/load_tutor.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
          titlecenter = tutorList.length.toString() + " Tutors Available";
        } else {
          titlecenter = "No Tutor Available";
          tutorList.clear();
        }
        if (mounted) setState((){});
      } else {
        //do something
        titlecenter = "No Tutor Available";
        tutorList.clear();
        setState(() {});
      }
    });
  }

  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ClipOval(
                    child: Material(
                        color: Colors.grey[200],
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.black,
                                size: 22,
                              ),
                            ))),
                  ),
                ),
                pinned: true,
                floating: false,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Tutor Details',
                      style: TextStyle(color: Colors.white)),
                  centerTitle: true,
                  background: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        child: SizedBox(
                            height: screenHeight / 2.5,
                            width: screenWidth,
                            child: Image.asset(
                                'assets/images/tutorbackground.png')),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 10,
                        child: CachedNetworkImage(
                          height: 100.0,
                          imageUrl: CONSTANTS.server +
                              "/276876/mytutor/mobile/assets/tutors/" +
                              tutorList[index].tutorId.toString() +
                              '.jpg',
                          fit: BoxFit.cover,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          width: 100,
                          placeholder: (context, url) =>
                              const LinearProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tutorList[index].tutorName.toString(),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 96, 95, 95)),
                      ),
                      const SizedBox(height: 40),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  const TextSpan(
                                      text: "Tutor Description: \n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                  TextSpan(
                                      text:
                                          tutorList[index].tutorDesc.toString(),
                                      style: const TextStyle(fontSize: 16)),
                                  const TextSpan(
                                      text: "\n\nEmail: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                  TextSpan(
                                      text: tutorList[index]
                                          .tutorEmail
                                          .toString(),
                                      style: const TextStyle(fontSize: 16)),
                                  const TextSpan(
                                      text: "\n\nPhone Number: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                  TextSpan(
                                      text: tutorList[index]
                                          .tutorPhone
                                          .toString(),
                                      style: const TextStyle(fontSize: 16)),
                                  const TextSpan(
                                      text: "\n\nSubject Responsible: \n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                  TextSpan(
                                      text: tutorList[index]
                                          .subjectName
                                          .toString(),
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search",
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: 'Search by tutor or subject name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadTutors(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }
}
