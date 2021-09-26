import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:health_app/vstatic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import 'account.dart';
import 'login.dart';

void main() => runApp(const MaterialApp(
  home: Create(),
  debugShowCheckedModeBanner: false,
));

class Create extends StatefulWidget {
  const Create({Key key}) : super(key: key);


  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {

  String _pass;
  bool _secure = true;
  bool _csecure = true;

  TextEditingController regno = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController emailid = new TextEditingController();
  TextEditingController gender = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController cpass = new TextEditingController();

  Future setall(String name,String reg,String email,String gen,String pas, String cpas ) async{
    var url = 'https://whospital123.000webhostapp.com/prj/create.php';
    await http.post(Uri.parse(url),body: {
      'user': reg,
      'pass': pas,
      'cpass': cpas,
      'name': name,
      'email': email,
      'gen': gen,
    });
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
              });
            },
            width: 140,
          ),
        ]
    ).show();
  }

  double stval;
  _mypstrength() {
    print("Called");
    if(_pass != null) {
      print("brfore Current Password s: $stval");
      if (_pass.length < 8) {
        return Text("Too short",
          style: TextStyle(
              color: Colors.red,
              fontSize: 17
          ),
        );
      }
      else if (stval >= 0.88) {
        print("Current Password s: $stval");
        return Text("Strong",
          style: TextStyle(
              color: Colors.green,
              fontSize: 17
          ),
        );
      }
      else {
        return Text("week",
          style: TextStyle(
              color: Colors.red,
              fontSize: 17
          ),
        );
      }
    }
    else{
      return Text("");
    }

  }

  showAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "Current password is not matched with new password.",
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
          ),
        ]

    ).show();
  }
  showAlert2(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "You Password is week.\n Please check!",
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
          ),
        ]

    ).show();
  }
  bool check(String nps,String cps){
    if (stval >= 0.88) {
      if (nps.compareTo(cps) == 0) {
        return true;
      }
      else {
        showAlert();
      }
    }
    else{
      showAlert2();
    }
    return false;
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

  warnAlertemail(String title, String data){
    Alert(
        onWillPopActive: true,
        context: context,
        title: title,
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
          ),
        ]
    ).show();
  }
  bool isEmail(String string) {
    if (EmailValidator.validate(string) != true) {
      warnAlertemail("Invalid Email address!", "This email address is not a valid input.");
      return false;
    }
    for(int i =0;i<Stat.login.length;i++){
      if(string.compareTo(Stat.login[i][3])==0){
        warnAlertemail("Invalid Email address!","This email address is already exist.");
        return false;
      }
    }
    return true;
  }
  scusAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Successful!",
        desc: "Your account has been created successfully. ",
        type: AlertType.success,
        closeIcon: Icon(Icons.close,
          size: 0,
        ),
        buttons: [
          DialogButton(
            child: Text("Sign in",
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
            width: 80,
          )
        ]
    ).show();
  }

  bool regcheck(String usrn){
    bool flag = false;
    for(int i=0;i<Stat.pas.length;i++){
      String aluser = Stat.login[i][0].toString();
      if(usrn.compareTo(aluser) == 0){
          flag = true;
          break;
      }
    }
    if(flag){
      warnAlertemail("User Already exist", "This registration number is already exist.");
      return false;
    }
    return true;
  }


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
          title: Text("Create account",
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
                    controller: username,
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
              SizedBox(
                  width: 370,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: regno,
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
              Text("Email:",
                style: TextStyle(
                    fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              SizedBox(
                  width: 370,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailid,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(45),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Enter Email-Id",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: false,
                  )
              ),
              SizedBox(height: 20,),
              Text("Gender:",
                style: TextStyle(
                    fontSize: 21
                ),
              ),
              SizedBox(height: 5,),
              SizedBox(
                  width: 370,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: gender,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: "Enter Gender",
                    ),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    autofocus: false,
                  )
              ),
              SizedBox(height: 20,),
              Text("Password:",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 55,
                child: TextField(
                  obscureText: _secure,
                  cursorHeight: 25,
                  controller: pass,
                  onChanged: (pass)=>setState((){_pass=pass;
                  }),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: 'Enter password',
                      suffixIcon: IconButton(icon: Icon(
                          _secure ? Icons.visibility_off_rounded:Icons.visibility_rounded),
                          onPressed: () {
                            setState(() {
                              _secure = !_secure;
                            });
                          }
                      )
                  ),
                  autofocus: false,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(" Aleast 8 Characters",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(" Aleast 1 special characters",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Password Stength :",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(width: 5,),
                    _mypstrength(),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 15),
                child: FlutterPasswordStrength(
                    password: _pass,
                    height: 10,
                    radius: 10,
                    backgroundColor: Colors.grey[350],
                    strengthCallback: (strength){
                      debugPrint(strength.toString());
                      stval = strength;
                    }
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 55,
                child: TextField(
                  obscureText: _csecure,
                  cursorHeight: 25,
                  controller: cpass,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                      ),
                      labelText: 'Confirm password',
                      suffixIcon: IconButton(icon: Icon(
                          _csecure ? Icons.visibility_off_rounded:Icons.visibility_rounded),
                          onPressed: () {
                            setState(() {
                              _csecure = !_csecure;
                            });
                          }
                      )
                  ),
                  autofocus: false,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                // ignore: deprecated_member_use
                child: RaisedButton(onPressed: () {
                  icheck().then((intenet) {
                    if ((intenet != null && intenet)!=true) {
                      internetAlert();
                    }
                    else{
                      setState(() {
                        String name = username.text.toString();
                        String reg = regno.text.toString();
                        String email = emailid.text.toString();
                        String gen = gender.text.toString();
                        String pas = pass.text.toString();
                        String cpas = cpass.text.toString();
                        if(name == ""||reg == ""|| email== ""||gen==""||pas==""||cpas==""){
                          warnAlert();
                        }
                        else{
                          if(check(pas,cpas)){
                            if(regcheck(reg)){
                              if(isEmail(email)){
                                setall(name,reg,email,gen,pas,cpas);
                                scusAlert();
                              }
                            }
                          }
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
                        width: 110,
                        child: Text('Create',
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

