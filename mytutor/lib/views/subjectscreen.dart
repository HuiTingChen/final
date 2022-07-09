import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mytutor/views/registerscreen.dart';
import '../constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:badges/badges.dart';

import '../models/subject.dart';
import '../models/user.dart';
import 'cartscreen.dart';
import 'loginscreen.dart';

class SubjectScreen extends StatefulWidget {
  final User user;
  const SubjectScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<Subject> subjectList = <Subject>[];
  String titlecenter = "";
  var rating = "";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  TextEditingController searchController = TextEditingController();
  String search = "";
  String arrangement = "ASC";
  int cart = 0;

  @override
  void initState() {
    super.initState();
    _loadSubjects(1, search, arrangement);
    _loadMyCart();
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
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Badge(
              position: BadgePosition.topEnd(top: 0, end: 3),
              animationType: BadgeAnimationType.scale,
              badgeContent: Text(
                widget.user.cart.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                onPressed: () async {
                  if (widget.user.email == "guest@gmail.com") {
                    _loadOptions();
                  } else {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => CartScreen(
                                  user: widget.user,
                                )));
                    _loadSubjects(1, search, arrangement);
                    _loadMyCart();
                  }
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: subjectList.isEmpty
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
                    child: GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: (4 / 5),
                        children: List.generate(subjectList.length, (index) {
                          return InkWell(
                            splashColor:
                                const Color.fromARGB(255, 156, 219, 213),
                            onTap: () => {_loadSubjectDetails(index)},
                            child: Card(
                                elevation: 5,
                                color: const Color.fromARGB(255, 220, 243, 241),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Column(
                                  children: [
                                    Flexible(
                                      flex: 6,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            child: CachedNetworkImage(
                                              imageUrl: CONSTANTS.server +
                                                  "/276876/mytutor/mobile/assets/courses/" +
                                                  subjectList[index]
                                                      .subjectId
                                                      .toString() +
                                                  '.png',
                                              fit: BoxFit.cover,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20)),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              width: resWidth,
                                              placeholder: (context, url) =>
                                                  const LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          const Positioned(
                                            bottom: 3,
                                            right: 2,
                                            child: Icon(Icons.circle,
                                                color: Colors.white,
                                                size: 40), //Icon
                                          ),
                                          Positioned(
                                            bottom: -3,
                                            right: -2,
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.red),
                                              onPressed: () {
                                                print("favorite");
                                                //_addFavorite(index);
                                              },
                                            ), //Icon
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Flexible(
                                        flex: 5,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    subjectList[index]
                                                        .subjectName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      RatingBarIndicator(
                                                        rating: double.parse(
                                                            subjectList[index]
                                                                .subjectRating
                                                                .toString()),
                                                        direction:
                                                            Axis.horizontal,
                                                        itemCount: 5,
                                                        itemSize: 12,
                                                        itemPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    2.0),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star_rounded,
                                                          color: Colors.amber,
                                                          size: 2,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        subjectList[index]
                                                            .subjectRating
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                      "RM " +
                                                          double.parse(subjectList[
                                                                      index]
                                                                  .subjectPrice
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .school_rounded,
                                                            size: 15),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                            subjectList[index]
                                                                    .subjectSessions
                                                                    .toString() +
                                                                " sessions",
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ]),
                                                ],
                                              ),
                                            ),
                                            const Positioned(
                                              bottom: 5,
                                              right: 2,
                                              child: Icon(Icons.circle,
                                                  color: Colors.white,
                                                  size: 40), //Icon
                                            ),
                                            Positioned(
                                              bottom: -1,
                                              right: -2,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.black),
                                                onPressed: () {
                                                  _addtocartDialog(index);
                                                },
                                              ), //Icon
                                            ),
                                          ],
                                        ))
                                  ],
                                )),
                          );
                        })),
                    //)
                  ),
                  SizedBox(
                    height: 35,
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
                              onPressed: () =>
                                  {_loadSubjects(index + 1, "", "")},
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

  void _loadSubjects(int pageno, String _search, String _arrangement) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(
            CONSTANTS.server + "/276876/mytutor/mobile/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
          'arrangement': _arrangement,
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
        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
          titlecenter = subjectList.length.toString() + " Subjects Available";
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Subject Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }

  _loadSubjectDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  leading: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 40,
                      width: 40,
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
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 40, width: 40),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: ClipOval(
                          child: Material(
                            color: Colors.grey[200],
                            child: Badge(
                              position: BadgePosition.topEnd(top: -4, end: 3),
                              animationType: BadgeAnimationType.scale,
                              badgeContent: Text(
                                widget.user.cart.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: -1,
                                    right: -1,
                                    child: IconButton(
                                      onPressed: () async {
                                        if (widget.user.email ==
                                            "guest@gmail.com") {
                                          _loadOptions();
                                        } else {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (content) =>
                                                      CartScreen(
                                                        user: widget.user,
                                                      )));
                                          _loadSubjects(1, search, arrangement);
                                          _loadMyCart();
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  pinned: true,
                  floating: false,
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text('Subject Details',
                        style: TextStyle(color: Colors.white)),
                    centerTitle: true,
                    background: Container(
                      color: Colors.white,
                      child: CachedNetworkImage(
                        height: 200.0,
                        imageUrl: CONSTANTS.server +
                            "/276876/mytutor/mobile/assets/courses/" +
                            subjectList[index].subjectId.toString() +
                            '.png',
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        width: resWidth,
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
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
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: screenWidth * (6 / 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    subjectList[index].subjectName.toString(),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 96, 95, 95)),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RatingBarIndicator(
                                        rating: double.parse(subjectList[index]
                                            .subjectRating
                                            .toString()),
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text(
                                        subjectList[index]
                                            .subjectRating
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: screenWidth * (3 / 10),
                              child: IconButton(
                                icon:
                                    const Icon(Icons.favorite_border, size: 45),
                                onPressed: () {
                                  print("favorite");
                                  //_addFavorite(index);
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  const TextSpan(
                                      text: "\nSubject Description: \n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                  TextSpan(
                                      text: subjectList[index]
                                          .subjectDesc
                                          .toString(),
                                      style: const TextStyle(
                                          height: 1.5, fontSize: 16)),
                                  const TextSpan(
                                      text: "\n\nTutor: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                  TextSpan(
                                      text: subjectList[index]
                                          .tutorName
                                          .toString(),
                                      style: const TextStyle(fontSize: 16)),
                                  const TextSpan(
                                      text: "\n\nSession: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16)),
                                  TextSpan(
                                      text: subjectList[index]
                                          .subjectSessions
                                          .toString(),
                                      style: const TextStyle(fontSize: 16)),
                                  const TextSpan(
                                      text: " sessions",
                                      style: TextStyle(fontSize: 16))
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              width: resWidth,
              height: 80,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 220, 243, 241),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: screenWidth * (3 / 10),
                    child: Text(
                      "RM " +
                          double.parse(
                                  subjectList[index].subjectPrice.toString())
                              .toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          _addtocartDialog(index);
                        },
                        child: const Text(
                          "Add to cart",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
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
                  "Search ",
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          labelText: 'Search by subject name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Price: ", style: TextStyle(fontSize: 15)),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  arrangement = "ASC";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(
                                    255, 220, 243, 241), // background
                                onPrimary: Colors.grey[700], // foreground
                              ),
                              child: const Text("ASC",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  arrangement = "DESC";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(
                                    255, 220, 243, 241), // background
                                onPrimary: Colors.grey[700], // foreground
                              ),
                              child: const Text("DESC",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      arrangement = arrangement;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search, arrangement);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  void _loadMyCart() {
    if (widget.user.email != "guest@gmail.com") {
      http.post(
          Uri.parse(CONSTANTS.server +
              "/276876/mytutor/mobile/php/load_mycartqty.php"),
          body: {
            "email": widget.user.email.toString(),
          }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      ).then((response) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          print(jsondata['data']['carttotal'].toString());
          setState(() {
            widget.user.cart = jsondata['data']['carttotal'].toString();
          });
        }
      });
    }
  }

  _addtocartDialog(int index) {
    if (widget.user.email == "guest@gmail.com") {
      _loadOptions();
    } else {
      _addtoCart(index);
    }
  }

  void _addtoCart(int index) {
    http.post(
        Uri.parse(
            CONSTANTS.server + "/276876/mytutor/mobile/php/insert_cart.php"),
        body: {
          "email": widget.user.email.toString(),
          "subjectid": subjectList[index].subjectId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Please select",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: _Login, child: const Text("Login"))),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      onPressed: _Register, child: const Text("Register")),
                ),
              ],
            ),
          );
        });
  }

  void _Login() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  void _Register() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const RegisterPage()));
  }
}
