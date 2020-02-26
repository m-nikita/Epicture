import 'package:flutter/material.dart';
import 'package:epicture/views/LoginView.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Epicture());

class Epicture extends StatelessWidget {

  Epicture() {
    SharedPreferences.setMockInitialValues({});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Epicture',
      theme: ThemeData(
        backgroundColor: Color(0xFF000000),
      ),
      home: LoginView()  // on va récup l'id et les données pour assurer la connexion au login
    );
  }
}