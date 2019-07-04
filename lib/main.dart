import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github_flutter/ui/HomePage.dart';
import 'package:github_flutter/ui/Network.dart';
import 'package:github_flutter/ui/Profile.dart';
import 'package:uni_links/uni_links.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navKeyStat;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _subs;
  final navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _initDeepLinkListener();
    super.initState();
    MyApp.navKeyStat = navKey;
  }

  @override
  void dispose() {
    _disposeDeepLinkListener();
    super.dispose();
  }

  void _initDeepLinkListener() async {
    _subs = getLinksStream().listen((String link) {
      print("init deeplink listener");
      _checkDeepLink(link);
    }, cancelOnError: true);
  }

  void _checkDeepLink(String link) {
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      proceedToProfile(code);
    }
  }

  void proceedToProfile(String code) async {
    _showLoading();
    bool p = await Network().loginWithGitHub(code);
    navKey.currentState.pop();
    if (p) {
      navKey.currentState.pushReplacementNamed("/profile");
    } else {
      showDialog(
        context: Login.popContext,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Some Server Error Occured, Please Try Again",
            ),
          );
        },
      );
      print("Server Error");
    }
  }

  void _disposeDeepLinkListener() {
    print("dispose deeplink listener");
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

  void _showLoading() {
    showDialog(
      context: Login.popContext,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future<bool>.value(false),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: true,
      title: 'FlutterMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => Login(),
        '/profile': (context) => HomePage(),
      },
    );
  }
}
