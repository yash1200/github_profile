import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_flutter/model/GithubLoginRequest.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class Network {
  static final Network _singleton = Network._internal();
  FirebaseUser _user;

  static const String GITHUB_CLIENT_ID = '19b3ed0f5967aada5763';
  static const String GITHUB_CLIENT_SECRET =
      '6e5c6928020870bda4f8b1cbfe787ce9098d3a1e';
  var url =
      'https://github.com/login/oauth/authorize?client_id=$GITHUB_CLIENT_ID'
      '&scope=public_repo%20read:user%20user:email%20user:username';

  FirebaseUser get user => _user;

  factory Network() {
    return _singleton;
  }

  Network._internal();

  Future<bool> loginWithGitHub(String code) async {
    print("called loginWithGithub");
    //ACCESS TOKEN REQUEST
    final response = await http.post(
      "https://github.com/login/oauth/access_token",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(
        GitHubLoginRequest(
          clientId: GITHUB_CLIENT_ID,
          clientSecret: GITHUB_CLIENT_SECRET,
          code: code,
        ),
      ),
    );
    GitHubLoginResponse loginResponse = GitHubLoginResponse.fromJson(
      json.decode(response.body),
    );

    print(loginResponse);

    final AuthCredential credential = GithubAuthProvider.getCredential(
      token: loginResponse.accessToken,
    );

    final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    Firestore.instance.collection('users').document(user.uid).setData(
      {
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl,
        'uid': user.uid,
      },
    );
    _user = user;

    if (_user == null) {
      return false;
    } else {
      return true;
    }
  }
}
