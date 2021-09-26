import 'dart:math';
import 'package:health_app/vstatic.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

void main() => runApp(MaterialApp(
  home: Write(),
  debugShowCheckedModeBanner: false,
));

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class Write extends StatefulWidget {
  const Write({Key key}) : super(key: key);

  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<Write> {


  Future setacc() async{
    var url2 = 'https://whospital123.000webhostapp.com/prj/getacc.php';
    http.Response response2 = await http.get(Uri.parse(url2));
    String data2 = (response2.body).toString();
    List acc2;
    acc2 = data2.split("#");
    int row2 = acc2.length-1;
    int col2 = 5;
    // ignore: deprecated_member_use
    Stat.temp = List.generate(row2, (i) => List(col2), growable: false);
    setState(() {
      for(int i=0;i<acc2.length-1;i++){
        Stat.temp[i] = acc2[i].split("  ");
      }
      print(Stat.temp);
    });
  }
  @override
  void initState(){
    setacc();
    super.initState();
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
            else{
              setacc();
            }
          });
        },),
        buttons: [
          DialogButton(
            child: Text("Try again",
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
                else{
                  setacc();
                }
              });
            },
            width: 140,
          ),
        ]
    ).show();
  }

  sendmail(int i) async{
    String username = 'do.not.reply.whospital@gmail.com';
    String password = 'midhun@123';
    Random random = new Random();
    int rnum = random.nextInt(900)+100;
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);
    final message1 = Message()
      ..from = Address(username, 'wHospital')
      ..recipients.add('${Stat.temp[i][3].toString().trim()}')
      ..subject = 'Medical Report from Dr.${Stat.login[Stat.usd][2]} [#eID$rnum]'
      ..html = "<!DOCTYPE html>"
          "<html><body style='background-color: white;'>"
          "<div><center>"
          "<img src='https://whospital123.000webhostapp.com/prj/logo.png' alt='Secure Bank'/><br>"
          "</center><h2>Hi ${Stat.temp[i][2]},</h2><br>"
          "<p>This is to inform you that,</p><br>"
          "<h5>A medical report has been generated in your history please check!</h5>"
          "<br>"
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
  }
  Future setall() async{
    var url = 'https://whospital123.000webhostapp.com/prj/settran.php';
    await http.post(Uri.parse(url),body: {
      'user': Stat.login[Stat.usd][0],
      'tname': Stat.ttemp[0],
      'mno': Stat.ttemp[1],
      'time': Stat.ttemp[2],
      'desp': Stat.ttemp[3],
    });
  }
  Future setreceiver(int i) async{
    var url = 'https://whospital123.000webhostapp.com/prj/setreceiver.php';
    await http.post(Uri.parse(url),body: {
      'user': Stat.temp[i][0],
      'tname': 'Dr.${Stat.ttemp[0]}',
      'mno': Stat.ttemp[1],
      'time': Stat.ttemp[2],
      'desp': Stat.ttemp[3],
    });
  }
  fecthall(String name,String num,String desp){
    if(name==""||num==""||desp==""){
      warnAlert();
    }
    else{
      if (num.compareTo(Stat.login[Stat.usd][0]) == 0) {
        warnAlert2("Sender and Receiver Registration number can't be same.\n$num");
      }
      else{
        flag = false;
        for (int i = 0; i < Stat.temp.length; i++) {
          if (num.compareTo(Stat.temp[i][0]) == 0) {
            Stat.ttemp.clear();
            Stat.ttemp.add(Stat.login[Stat.usd][2]);
            Stat.ttemp.add(Stat.login[Stat.usd][0]);
            Stat.ttemp.add(date);
            Stat.ttemp.add(desp);
            setreceiver(i);
            sendmail(i);
            flag = true;
          }
        }
        if(flag) {
          Stat.ttemp.clear();
          Stat.ttemp.add(name);
          Stat.ttemp.add(num);
          Stat.ttemp.add(date);
          Stat.ttemp.add(desp);
          Stat.transac.add([]);
          Stat.transac[Stat.transac.length - 1].add(name);
          Stat.transac[Stat.transac.length - 1].add(num);
          Stat.transac[Stat.transac.length - 1].add(date);
          Stat.transac[Stat.transac.length - 1].add(desp);
          setall();
          scusAlert();
        }
        else{
          warnAlert2("This Registration number is not registered.");
        }
      }
    }
  }
  scusAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Successful!",
        desc: "Medical prescription sent to ${Stat.ttemp[0]} Successfully. ",
        type: AlertType.success,
        closeIcon: Icon(Icons.close),
        buttons: [
          DialogButton(
            child: Text("ok",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            width: 80,
          )
        ]
    ).show();
  }
  warnAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "All fields are Mandatory\nPlease check!",
        type: AlertType.warning,
        closeIcon: Icon(Icons.close),
        buttons: [
          DialogButton(
            child: Text("Try again",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              Navigator.pop(context);
            },
            width: 140,
          )
        ]
    ).show();
  }
  warnAlert2(String data){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "User Not Found!",
        desc: "$data",
        type: AlertType.warning,
        closeIcon: Icon(Icons.close),
        buttons: [
          DialogButton(
            child: Text("Try again",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              Navigator.pop(context);
            },
            width: 140,
          )
        ]
    ).show();
  }
  bool flag = false;
  String date = Jiffy().format('MMM do, yyyy, h:mm a');
  TextEditingController inp1 = new TextEditingController();
  TextEditingController inp2 = new TextEditingController();
  TextEditingController inp3 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          brightness: Brightness.dark,
          shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60.0),
              bottomRight:  Radius.circular(60.0),
            ),
          ),
          title: Text("Send prescription",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          elevation: 5,
          backgroundColor: Colors.purple,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Name:",
                style: TextStyle(
                    fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              Container(
                  width: 370,
                  height: 50,
                  child: TextField(
                    controller: inp1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Enter Student Name",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: false,
                  )
              ),
              SizedBox(height: 20,),
              Text("Registration Number:",
                style: TextStyle(
                    fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              Container(
                  width: 370,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: inp2,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                      UpperCaseTextFormatter(),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Enter Registration Number",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: false,
                  )
              ),
              SizedBox(height: 20,),
              Text("Prescription:",
                style: TextStyle(
                    fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              SingleChildScrollView(
                child: Container(
                    width: 370,
                    height: 250,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      controller: inp3,
                      maxLength: 2000,
                      maxLines: 100,
                      cursorHeight: 23,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        labelText: "Type Medical Prescription here",
                      ),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      autofocus: false,
                    )
                ),
              ),
              SizedBox(height: 20,),
              Center(
                // ignore: deprecated_member_use
                child: RaisedButton(onPressed: () {
                  icheck().then((intenet) {
                    if ((intenet != null && intenet)!=true) {
                      internetAlert();
                    }
                    else{
                      setState(() {
                        String name = inp1.text.toString();
                        String num = inp2.text.toString();
                        String pres = inp3.text.toString();
                        fecthall(name,num,pres);
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
                        width: 110,
                        child: Text('Send',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24
                          ),
                        ),
                      ),
                    )
                ),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}



