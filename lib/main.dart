import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:covid19app/constants.dart';
import 'package:covid19app/home_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      data: (brightness) {
        return ThemeData(
          primaryColor: Colors.black,
          brightness: brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
          scaffoldBackgroundColor: brightness == Brightness.dark
              ? Colors.blueGrey[900]
              : Colors.white,
        );
      },
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Covid19 App',
          theme: theme,
          home: HomeScreenCheck(),
        );
      },
    );
  }
}

class HomeScreenCheck extends StatefulWidget {
  @override
  _HomeScreenCheckState createState() => _HomeScreenCheckState();
}

class _HomeScreenCheckState extends State<HomeScreenCheck> {

  ConnectivityResult previous;

  @override
  void initState() {
    super.initState();
    try {
      InternetAddress.lookup('google.com').then((result) {
        if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // internet connection is available
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
        }
        else {
          // No connection
          _showdialog();
        }
      }).catchError((error) {
        // No connection
        _showdialog();
      });
    } on SocketException catch(_) {
      // no connection
      _showdialog();
    }

    Connectivity().onConnectivityChanged.listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {

      }
      else if (previous == ConnectivityResult.none) {
        // internet connection
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
      }
      previous = connresult;
    });
  }


  void _showdialog(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ERROR'),
        content: Text("No Internet Detected."),
        actions: <Widget>[
          FlatButton(
            // method to exit application programmatically
            onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: Text("Exit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(padding: EdgeInsets.only(top: 20.0),child: Text("Checking you Internet Connection."),),
          ],
        ),
      ),
    );
  }
}
