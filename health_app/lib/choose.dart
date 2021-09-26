import 'package:flutter/material.dart';
import 'package:health_app/vstatic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dlogin.dart';
import 'login.dart';

void main() => runApp(const MaterialApp(
  home: Choose(),
  debugShowCheckedModeBanner: false,
));

class Choose extends StatefulWidget {
  const Choose({Key key}) : super(key: key);

  @override
  _ChooseState createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  String page = "Student";
  bool check = false;
  bool main = false;

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Fpage', page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.asset('assets/Choose.png'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50,),
                  const Text("Login as",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(5),
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(page,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        Row(
                          children: [
                            const VerticalDivider(
                              thickness: 5,
                              color: Colors.black,
                              width: 1,
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if(page == "Student"){
                                      page = "Doctor";
                                    }
                                    else{
                                      page = "Student";
                                    }

                                  });
                                },
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 25,
                                )
                            )
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(

                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.1,
                        child: Checkbox(
                          activeColor: Colors.purple,
                          value: check,
                          onChanged: (bool value) {
                            setState(() {
                              if(check){
                                check = false;
                              }
                              else{
                                check = true;
                              }
                            });
                          },
                        ),
                      ),
                      const Text("Remember me",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w400
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: RaisedButton(onPressed: () {
                      setState(() {
                        if(check) {
                          addStringToSF();

                        }
                        if(page == "Student") {
                          Stat.mpage = "Student";
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                        }
                        else{
                          Stat.mpage = "Doctor";
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Dlogin()));
                        }
                      });
                    },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.grey[600]),
                        ),
                        color: Colors.purple,
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            alignment: Alignment.center,
                            width: 100,
                            child: const Text('Next',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

