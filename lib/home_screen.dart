import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:covid19app/country_data.dart';
import 'package:covid19app/pages/state_page.dart';
import 'package:covid19app/widgets/worldpanel.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19app/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription connectivitySubscription;

  ConnectivityResult _previousResult;

  bool dialogshown = false;

  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  Map worldData;
  GlobalKey _bottomNavigationKey = GlobalKey();

  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  Future fetchData() async {
    fetchWorldWideData();
  }

  @override
  void initState() {
    fetchData();
    super.initState();

    connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult connresult) {
        if (connresult == ConnectivityResult.none) {
          dialogshown = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            child: AlertDialog(
              title: Text("ERROR"),
              content: Text("Internet Connection is not available."),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                  },
                  child: Text("Exit"),
                )
              ],
            ),
          );
        } else if (_previousResult == ConnectivityResult.none) {
          checkinternet().then(
            (result) {
              if (result == true) {
                dialogshown = false;
                Navigator.pop(context);
              }
            },
          );
        }

        _previousResult = connresult;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50,
        color: kTextColor,
        buttonBackgroundColor: kTextColor,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.blueGrey[900]
            : Colors.white,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: kPrimaryColor),
          Icon(CupertinoIcons.location_solid, size: 30, color: kPrimaryColor),
        ],
        animationDuration: Duration(
          milliseconds: 200,
        ),
        onTap: (index) {
          if (index == 1) {
            setState(() {
              index = 0;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return StatePage();
                },
              ),
            );
          } else if (index == 0) {}
        },
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Worldwide',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountryData()));
                      }, // here insert the page for the country wise data
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: kTextColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          'Country Wise',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              worldData == null
                  ? Center(child: CircularProgressIndicator())
                  : WorldPanel(
                      worldData: worldData,
                    ),
              SizedBox(
                height: 20,
              ), // builds the panel for the world data
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "  Preventions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: buildPrevention(context),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildHelpCard(context),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildHelpCard(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.4,
              top: 20,
              right: 20,
            ),
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF60BE93),
                  Color(0xFF1B8D59),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Dial 1075 for \nMedical Help!\n",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  ),
                  TextSpan(
                      text: "If any symptoms appear",
                      style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SvgPicture.asset("assets/icons/nurse.svg"),
          ),
          Positioned(
              top: 30,
              right: 10,
              child: SvgPicture.asset("assets/icons/virus.svg")),
        ],
      ),
    );
  }

  Row buildPrevention(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        PreventionCard(
          svgSrc: "assets/icons/hand_wash.svg",
          message: "Wash Hands",
        ),
        PreventionCard(
          svgSrc: "assets/icons/use_mask.svg",
          message: "Use Masks",
        ),
        PreventionCard(
          svgSrc: "assets/icons/Clean_Disinfect.svg",
          message: "Clean the surfaces\n with Disinfectant",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kTextColor,
      title: Text(
        'Co-Tracker',
        style: TextStyle(
          letterSpacing: 0.5,
        ),
      ),
      elevation: 4, // THis gives a slight shadow  at the bottom
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.light
                ? Icons.lightbulb_outline
                : Icons.highlight,
            color: kPrimaryColor,
          ),
          onPressed: () {
            DynamicTheme.of(context).setBrightness(
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light);
          },
        )
      ],
    );
  }
}

class PreventionCard extends StatelessWidget {
  final String svgSrc;
  final String message;
  const PreventionCard({
    Key key,
    this.svgSrc,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(svgSrc),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: kPrimaryColor),
          ),
        )
      ],
    );
  }
}
