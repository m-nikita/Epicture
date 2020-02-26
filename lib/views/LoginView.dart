import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'package:epicture/components/NavigationBar.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  bool isLoggedIn = false;
  //final String clientId = "7962edbdceeb196"; //ID Quentin
  final String clientId = "02fde0fac65a1eb"; // ID Nikita
  final String responseType = "token";
  final webViewPlugin = new FlutterWebviewPlugin(); //webview faisant apparaître le login Imgur sur l'app

  @override
  void initState() {
    super.initState();
    
    webViewPlugin.onStateChanged.listen((WebViewStateChanged state) {

      var uri = Uri.parse(state.url.replaceFirst('#', '?'));

      if (uri.query.contains('access_token')) {
          webViewPlugin.close();

          SharedPreferences.getInstance().then((SharedPreferences prefs) {
              print(state.url);
              print("SHARED: " + uri.queryParameters["access_token"]);
              prefs.setString('user_access_token', uri.queryParameters["access_token"]);
              prefs.setString('user_refresh_token', uri.queryParameters["refresh_token"]);
              prefs.setString('user_account_name', uri.queryParameters["account_username"]);
              prefs.setString('account_id', clientId);
              setState(() {
                  this.isLoggedIn = true;
              });
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!this.isLoggedIn) {
      return WebviewScaffold(
          url: "https://api.imgur.com/oauth2/authorize?client_id=" + clientId +
              "&response_type=" + responseType,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                  backgroundColor: Colors.black45,
                  title: Text("Connexion"),
                  centerTitle: true,
              ),
          )
      );
    } else {
      return NavigationBarWidget();
    }
  }
}
