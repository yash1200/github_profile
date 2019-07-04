import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_flutter/model/GithubLoginRequest.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  static BuildContext popContext;

  static const String GITHUB_CLIENT_ID = '19b3ed0f5967aada5763';
  static const String GITHUB_CLIENT_SECRET =
      '6e5c6928020870bda4f8b1cbfe787ce9098d3a1e';
  var url =
      'https://github.com/login/oauth/authorize?client_id=$GITHUB_CLIENT_ID'
      '&scope=public_repo%20read:user%20user:email%20user:username';

  @override
  Widget build(BuildContext context) {
    popContext = context;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Flutter-Mate',
                style: TextStyle(color: Colors.blue, fontSize: 40),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                "Login with Github",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                    forceWebView: false,
                  );
                } else {
                  print("CANNOT LAUNCH THIS URL!");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
