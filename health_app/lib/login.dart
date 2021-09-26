import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/validation.dart';
import 'package:health_app/vstatic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

import 'account.dart';
import 'create.dart';

void main() => runApp(const MaterialApp(

  home: Login(),
  debugShowCheckedModeBanner: false,
));

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  restPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Fpage', "");
  }

  @override
  void initState(){
    Future.delayed(Duration.zero,() async {
      try{
        var url = 'https://whospital123.000webhostapp.com/prj/getacc.php';
        http.Response response = await http.get(Uri.parse(url));
        String data = (response.body).toString();
        List acc;
        acc = data.split("#");
        int row = acc.length-1;
        int col = 5;
        // ignore: deprecated_member_use
        Stat.login = List.generate(row, (i) => List.filled(col, null, growable: false), growable: false);
        // ignore: deprecated_member_use
        Stat.pas = List<String>(row);
        // ignore: deprecated_member_use
        Stat.balance = List<String>(row);
        setState(() {
          for(int i=0;i<acc.length-1;i++){
            Stat.login[i] = acc[i].split("  ");
            Stat.pas[i] = Stat.login[i][1].toString().trim();
            Stat.balance[i] = Stat.login[i][4].toString().trim();
          }
          print("await");
          print(Stat.update1);
          Stat.update1 = false;
        });
      }
      catch(e){
        print("Cauth");
        Stat.update1 = true;
        print(Stat.update1);
      }
    });
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
        closeIcon: IconButton(icon: const Icon(Icons.close),onPressed:(){
          Navigator.pop(context);
          icheck().then((intenet) {
            if ((intenet != null && intenet) != true) {
              internetAlert();
            }
            else {
              Stat.update1 = false;
              Phoenix.rebirth(context);
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
                else{
                  Stat.update1 = false;
                  Phoenix.rebirth(context);
                }
              });
            },
            width: 140,
          ),
        ]
    ).show();
  }
  TextEditingController inp1 = TextEditingController();
  TextEditingController inp2 = TextEditingController();
  TextEditingController inp3 = TextEditingController();
  TextEditingController inp4 = TextEditingController();
  String usr='',psw='';
  String user, pasword;
  bool _secure = true;

  check(String usrn,String pasw){
    bool flag = false;
    for(int i=0;i<Stat.pas.length;i++){
      user = Stat.login[i][0].toString();
      pasword = Stat.pas [i].toString();
      if(usrn.compareTo(user) == 0){
        if(pasw.compareTo(pasword) == 0){
          Stat.usd = i;
          flag = true;
          break;
        }
      }
    }
    if(flag){
      if(Stat.verification == Stat.login[Stat.usd][3]){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Account()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => Valid()));
      }
    }
    else{
      showAlert();
    }

  }

  warnAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "Incorrect Username!",
        type: AlertType.warning,
        closeIcon: const Icon(Icons.close),
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
            },
            width: 140,
          ),
        ]
    ).show();
  }

  bool checkuser(){
    for(int i=0;i<Stat.login.length;i++){
      if(inp3.text.toString().compareTo(Stat.login[i][0])==0){
        Stat.usd = i;
        return true;
      }
    }
    return false;
  }

  newAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Registration Number",
        desc: "To rest password you need to enter the Registration number",
        content: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SizedBox(
            height: 55,
            child: TextField(
              cursorHeight: 24,
              controller: inp3,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                labelText: 'Enter Registration number',
              ),
              autofocus: false,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
        closeIcon: IconButton(icon: const Icon(Icons.close),onPressed:(){
          Navigator.pop(context);
          setState(() {
            Stat.ramail="";
            Stat.page = "";
          });
        },),
        buttons: [
          DialogButton(
            child: const Text("Confirm",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
              ),
            ),
            color: Colors.purple,
            onPressed: () {
              icheck().then((intenet) {
                if ((intenet != null && intenet)!=true) {
                  internetAlert();
                }
                else{
                  setState(() {
                    if(checkuser()){
                      Navigator.pop(context);
                      Stat.ramail="rmail";
                      Stat.page="Reset";
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Valid()));
                    }
                    else{
                      Stat.page="";
                      warnAlert();
                    }
                  });
                }
              });
            },
            width: 130,
          )
        ]
    ).show();
  }

  showAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "Invalid Username/password.",
        type: AlertType.warning,
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
              Phoenix.rebirth(context);
            },
            width: 140,
          ),
        ]
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          brightness: Brightness.dark,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(70.0),
              bottomRight: Radius.circular(70.0),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Student Login',
                    style: TextStyle(
                        fontSize: 25
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Create()));
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Text("Sign-Up",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          backgroundColor: Colors.purple,
          elevation: 10.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 45.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset('assets/logo.png',
                  height: 150,
                  width: 500,
                ),
              ),
              const SizedBox(height: 25,),
              const Text(
                'Registration No:',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(height: 15.0,),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 350,
                        height: 50,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorHeight: 25,
                          controller: inp1,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius
                                    .circular(10))
                            ),
                            labelText: 'Enter Registration Number',
                          ),
                          autofocus: false,
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        )
                    )
                  ]
              ),
              const SizedBox(height: 20.0,),
              const Text(
                'Password:',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(height: 15.0,),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: TextField(
                        obscureText: _secure,
                        cursorHeight: 25,
                        controller: inp2,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius
                                    .circular(10))
                            ),
                            labelText: 'Enter password',
                            suffixIcon: IconButton(icon: Icon(
                                _secure ? Icons.visibility_off_rounded : Icons
                                    .visibility_rounded),
                                onPressed: () {
                                  setState(() {
                                    _secure = !_secure;
                                  });
                                }
                            )
                        ),
                        autofocus: false,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ]
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  setState(() {
                    inp3.text = "";
                    newAlert();
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "Forgot password?",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue[900]
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Center(
                // ignore: deprecated_member_use
                child: RaisedButton(onPressed: () {
                  setState(() {
                    usr = inp1.text;
                    psw = inp2.text;
                    icheck().then((intenet) {
                      if ((intenet != null && intenet) != true) {
                        internetAlert();
                      }
                      else {
                          check(usr.toString(), psw.toString());
                      }
                    });
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
                        child: const Text('Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24
                          ),
                        ),
                      ),
                    )
                ),
              ),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a Student?",
                      style: TextStyle(
                        fontSize: 15
                      )
                    ),
                    TextButton(onPressed: () {
                      restPage();
                      Phoenix.rebirth(context);
                    },
                        child: const Text("Login as Doctor",
                            style: TextStyle(
                                fontSize: 15
                            )
                        )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
