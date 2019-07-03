import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  static const String GITHUB_CLIENT_ID = '19b3ed0f5967aada5763';
  static const String GITHUB_CLIENT_SECRET =
      '6e5c6928020870bda4f8b1cbfe787ce9098d3a1e';
  var url =
      'https://github.com/login/oauth/authorize?client_id=$GITHUB_CLIENT_ID';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: 'url',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
