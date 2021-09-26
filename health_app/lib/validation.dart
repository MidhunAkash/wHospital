import 'dart:async';
import 'package:health_app/password.dart';
import 'package:health_app/vstatic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';
import 'daccount.dart';


void main() => runApp(MaterialApp(
  home: Valid(),
  debugShowCheckedModeBanner: false,
));

class Valid extends StatefulWidget {
  @override
  _ValidState createState() => _ValidState();
}

class _ValidState extends State<Valid> {

  rigEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Vemail', email);
  }

  Future<bool> icheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  internetAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "NO INTERNET",
        desc: "Please check your network connection.",
        type: AlertType.info,
        closeIcon: IconButton(icon: Icon(Icons.close),onPressed:(){
          Navigator.pop(context);
          icheck().then((intenet) {
            if ((intenet != null && intenet) != true) {
              internetAlert();
            }
          });
        },),
        buttons: [
          DialogButton(
            child: const Text("Try again",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              Navigator.pop(context);
              icheck().then((intenet) {
                if ((intenet != null && intenet)!=true) {
                  internetAlert();
                }
              });
            },
            width: 140,
          ),
        ]
    ).show();
  }

  String date = Jiffy().format('MMM do, yyyy, h:mm a');


  String ematter(){
    if(Stat.ramail.compareTo("rmail")==0){
      return "A password reset requires a further verification because we need to ensure whether "
          "it is you are not. To complete the process enter "
          "the verification code in your device.";
    }
    else if(Stat.ramail.compareTo("vmail")==0){
      return "To change the email address it requires a further verification because we need to ensure whether "
          "it is you are not. To complete the process enter "
          "the verification code in your device.";
    }
    return "A sign in attempt requires further verification as a part of "
        "two-step verification for ensuring that it's you. To complete the sign in, "
        "enter the verification code in your device.";
  }
  sendmail() async {
    String username = 'do.not.reply.whospital@gmail.com';
    String password = 'midhun@123';
    Random random = new Random();
    Stat.rnum = random.nextInt(90000) + 10000;
    int rnum = random.nextInt(900)+100;
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);
    final message1 = Message()
      ..from = Address(username, 'wHospital')
      ..recipients.add('${Stat.login[Stat.usd][3]}')
      ..subject = 'Verification Code [#eID$rnum]'
      ..html = "<!DOCTYPE html>"
          "<html><head><style type='text/css' data-hse-inline-css='true'>.card{width: auto;height: auto;display: inline-block;box-shadow: 2px 2px 20px rgba(83, 83, 83, 0.664);"
          "border-radius: 15px; margin: 1%;padding-left: 3%;padding-right: 3%;} </style></head>"
          "<body style='background-color: white;'>"
          "<div class='back'><center>"
          "<img src='https://whospital123.000webhostapp.com/prj/logo.png' alt='Secure Bank'/><br>"
          "</center><h2>Hi ${Stat.login[Stat.usd][2]},</h2><br>"
          "<p>${ematter()}</p>"
          "<center><div style='width: auto;height: auto;display: inline-block;box-shadow: 2px 2px 20px rgba(83, 83, 83, 0.664);border-radius: 15px; margin: 1%;padding-left: 3%;padding-right: 3%;'><h1>${Stat.rnum}</h1></div></center>"
          "<p>If you have any other questions, feel free to reach out."
          " We will be glad to help in any way we can!<br>"
          "<br>Thanks for being a part of the wHospital Service!!</p>"
          "<p>Best Regards,<br>"
          "wHospital</p></div></body></html>";
    try {
      final sendReport = await send(message1, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  Timer _timer;
  int _start = 25;
  int _expire = 59;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          print(_timer);
        } else {
          setState(() {
            _start--;
          });
        }

      },
    );
  }
  void startTimer2() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_expire == 0) {
          setState(() {
            timer.cancel();
            if(Stat.ramail.compareTo("vmail")==0){
              Stat.ramail="";
              if(Stat.mpage.compareTo("Doctor")==0){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Daccount()));
              }
              else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
              }
            }
            else{
              Random random = Random();
              Stat.rnum = random.nextInt(90000) + 10000;
            }
          });
          print(_timer);
        } else {
          setState(() {
            _expire--;
          });
        }

      },
    );
  }
  @override
  void initState(){
    Future.delayed(Duration.zero,() async {
      String username = 'do.not.reply.whospital@gmail.com';
      String password = 'midhun@123';
      Random random = new Random();
      Stat.rnum = random.nextInt(90000) + 10000;
      int rnum = random.nextInt(900)+100;
      // ignore: deprecated_member_use
      final smtpServer = gmail(username, password);
      final message1 = Message()
        ..from = Address(username, 'wHospital')
        ..recipients.add('${Stat.login[Stat.usd][3]}')
        ..subject = 'Verification Code [#eID$rnum]'
        ..html = "<!DOCTYPE html>"
            "<html><head><style type='text/css' data-hse-inline-css='true'>.card{width: auto;height: auto;display: inline-block;box-shadow: 2px 2px 20px rgba(83, 83, 83, 0.664);"
            "border-radius: 15px; margin: 1%;padding-left: 3%;padding-right: 3%;} </style></head>"
            "<body style='background-color: white;'>"
            "<div class='back'><center>"
            "<img src='https://whospital123.000webhostapp.com/prj/logo.png' alt='Secure Bank'/><br>"
            "</center><h2>Hi ${Stat.login[Stat.usd][2]},</h2><br>"
            "<p>${ematter()}</p>"
            "<center><div style='width: auto;height: auto;display: inline-block;box-shadow: 2px 2px 20px rgba(83, 83, 83, 0.664);border-radius: 15px; margin: 1%;padding-left: 3%;padding-right: 3%;'><h1>${Stat.rnum}</h1></div></center>"
            "<p>If you have any other questions, feel free to reach out."
            " We will be glad to help in any way we can!<br>"
            "<br>Thanks for being a part of the wHospital Service!</p>"
            "<p>Best Regards,<br>"
            "wHospital</p></div></body></html>";
      try {
        final sendReport = await send(message1, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
      var url = 'https://whospital123.000webhostapp.com/prj/createtran.php';
      await http.post(Uri.parse(url),body: {
        'tname': Stat.login[Stat.usd][0],
      });
      var url2 = 'https://whospital123.000webhostapp.com/prj/getran.php';
      http.Response response = await http.post(Uri.parse(url2),body: {
        'tname': Stat.login[Stat.usd][0]
      });
      String data = (response.body).toString();
      List acc;
      acc = data.split("#");
      int row = acc.length-1;
      int col = 4;
      // ignore: deprecated_member_use
      Stat.transac = List.generate(row, (i) => List(col));
      for(int i=0;i<acc.length-1;i++){
        Stat.transac[i] = acc[i].split("  ");
        for(int j =0;j<4;j++){
          Stat.transac[i][j].trim();
        }
      }
      print(Stat.transac);
      print(Stat.transac==null);
      var url3 = 'https://whospital123.000webhostapp.com/prj/getdoc.php';
      http.Response response2 = await http.get(Uri.parse(url3));
      String data2 = (response2.body).toString();
      List acc2;
      acc2 = data2.split("#");
      int row2 = acc2.length-1;
      int col2 = 5;
      // ignore: deprecated_member_use
      Stat.dlogin = List.generate(row2, (i) => List(col2), growable: false);
      setState(() {
        for(int i=0;i<acc2.length-1;i++){
          Stat.dlogin[i] = acc2[i].split("  ");
        }
      });
    });
    super.initState();
    startTimer();
    startTimer2();
  }
  disptime(){
    if(_start!=0){
      return Text("  in $_start sec",
        style: TextStyle(
          fontSize: 17,
        ),
      );
    }
    else{
      return Text("");
    }
  }


  TextEditingController inp1 = new TextEditingController();

  Future<bool> _onWillPop() {
    return Alert(
        onWillPopActive: true,
        context: context,
        title: "Are you sure ?",
        desc: "Do you really want to stop the verification Process?",
        type: AlertType.none,
        closeIcon: Icon(Icons.close),
        buttons: [
          DialogButton(
            child: Text("No",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            width: 60,
          ),
          DialogButton(
            child: Text("Yes",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              if(Stat.ramail.compareTo("vmail")==0){
                Stat.ramail = "";
                if(Stat.mpage.compareTo("Doctor")==0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Daccount()));
                }
                else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
                }
              }
              else{
                Phoenix.rebirth(context);
              }
            },
            width: 80,
          )
        ]
    ).show();
  }

  resendColr(){
    if(_start != 0){
      return TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          color: Colors.grey[500]
      );
    }
    else{
      return TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          color: Colors.blue[900]
      );
    }
  }

  warnAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Verification Failed!",
        desc: "Incorrect verification code you are not allowed to access this account.\nPress the log-out to login again.",
        type: AlertType.error,
        closeIcon: Icon(Icons.ac_unit,size: 0.1,),
        buttons: [
          DialogButton(
            child: Text("Log Out",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              Phoenix.rebirth(context);
            },
            width: 140,
          ),
        ]
    ).show();
  }
  susAlert2(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Verified!",
        desc: "Your authentication is verified.\nPress next to continue.",
        type: AlertType.success,
        closeIcon: Icon(Icons.ac_unit,size: 0.1,),
        buttons: [
          DialogButton(
            child: Text("Next",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              Navigator.pop(context);
              if(Stat.page.compareTo("Reset")==0){
                Stat.page="Reset";
                Navigator.push(context, MaterialPageRoute(builder: (context) => Pasword()));
              }
              else{
                Stat.page="";
                print(Stat.page);
                if(Stat.mpage.compareTo("Doctor")==0){
                  rigEmail(Stat.login[Stat.usd][3]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Daccount()));
                }
                else{
                  rigEmail(Stat.login[Stat.usd][3]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
                }
              }
            },
            width: 140,
          ),
        ]
    ).show();
  }

  String exdata(){
    if(_expire==0){
      return "expired.";
    }
    return "expires in $_expire sec.";
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            brightness: Brightness.dark,
            titleSpacing: 1.0,
            automaticallyImplyLeading: false,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60.0),
                bottomRight:  Radius.circular(60.0),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                  setState(() {
                    _onWillPop();
                  });
                  },
                ),
                const Text("Authentication",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            elevation: 5,
            backgroundColor: Colors.purple,
          ),
        ),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Container(
                  height: 145,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0,0),
                          blurRadius: 2.0)
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 290.0,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child:Text("• Please check your e-mail.\n ${Stat.login[Stat.usd][3].toString().replaceRange(2, 11,"*********")}."),
                            )
                        ),
                        Container(
                            width: 300.0,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child:Text("• If you din't received any email."),
                            )
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    if(_start==0){
                                      _start = 25;
                                      _expire = 59;
                                      startTimer();
                                      startTimer2();
                                      sendmail();
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Resend Notification",
                                      style: resendColr(),
                                    ),
                                    disptime(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Verification code ${exdata()}",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 60,),
                Text("Verification Code: ",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                      width: 150,
                      height: 50,
                      child: TextField(
                        cursorHeight: 30,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: inp1,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),
                        ],
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 30,
                          letterSpacing: 10,
                        ),
                        autofocus: false,
                      )
                  ),
                ),
                SizedBox(height: 40,),
                Center(
                  // ignore: deprecated_member_use
                  child: RaisedButton(onPressed: () {
                    icheck().then((intenet) {
                      if ((intenet != null && intenet)!=true) {
                        internetAlert();
                      }
                      else{
                        setState(() {
                          if(inp1.text.toString().compareTo(Stat.rnum.toString())==0){
                            _timer.cancel();
                            if(Stat.ramail.compareTo("vmail")==0){
                              if(Stat.mpage.compareTo("Doctor")==0){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Daccount()));
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Account()));
                              }
                            }
                            else{
                              Stat.ramail="";
                              susAlert2();
                            }
                          }
                          else{
                            _timer.cancel();
                            warnAlert();
                          }
                        });
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
                          child: Text('Verify',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24
                            ),
                          ),
                        ),
                      )
                  ),
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        )
      ),
    );
  }
}

