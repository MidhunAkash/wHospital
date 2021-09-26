import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:health_app/vstatic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'choose.dart';
import 'dlogin.dart';
import 'login.dart';

void main() async {

  runApp(Phoenix(
    child:
    const MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    setState(() {
      Stat.fscreen = prefs.getString('Fpage');
      Stat.verification = prefs.getString('Vemail');
    });
    //return Globals.strValue;
  }
  @override
  void initState(){
    super.initState();
    getStringValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health Care',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        home: Stat.fscreen == "Student" ? Login() : Stat.fscreen == "Doctor" ? const Dlogin() : const Choose(),
    );
  }
}



