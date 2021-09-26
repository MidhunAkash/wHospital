import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:health_app/password.dart';
import 'package:health_app/transac.dart';
import 'package:health_app/validation.dart';
import 'package:health_app/vstatic.dart';
import 'package:health_app/write.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:connectivity/connectivity.dart';


void main() => runApp(MaterialApp(
  home: Daccount(),
  debugShowCheckedModeBanner: false,
));

class Daccount extends StatefulWidget {
  const Daccount({Key key}) : super(key: key);

  @override
  _DaccountState createState() => _DaccountState();
}

class _DaccountState extends State<Daccount> {
  TextEditingController inp3 = new TextEditingController();
  TextEditingController inp4 = new TextEditingController();
  Future updatene() async{
    var url = 'https://whospital123.000webhostapp.com/prj/dupdatene.php';
    await http.post(Uri.parse(url),body: {
      'user': Stat.login[Stat.usd][0],
      'name': Stat.login[Stat.usd][2],
      'email': Stat.login[Stat.usd][3]
    });
  }
  Future setall() async{
    var url2 = 'https://whospital123.000webhostapp.com/prj/getdoc.php';
    http.Response response2 = await http.get(Uri.parse(url2));
    String data2 = (response2.body).toString();
    List acc2;
    acc2 = data2.split("#");
    int row2 = acc2.length-1;
    int col2 = 5;
    // ignore: deprecated_member_use
    Stat.login = List.generate(row2, (i) => List(col2), growable: false);
    // ignore: deprecated_member_use
    Stat.pas = List<String>(row2);
    // ignore: deprecated_member_use
    Stat.balance = List<String>(row2);
    setState(() {
      for(int i=0;i<acc2.length-1;i++){
        Stat.login[i] = acc2[i].split("  ");
        Stat.pas[i] = Stat.login[i][1].toString().trim();
        Stat.balance[i] = Stat.login[i][4].toString().trim();
      }
    });
    var url = 'https://whospital123.000webhostapp.com/prj/getdoc.php';
    http.Response response = await http.post(Uri.parse(url),body: {
      'tname': Stat.login[Stat.usd][0]
    });
    String data = (response.body).toString();
    List acc;
    acc = data.split("#");
    int row = acc.length-1;
    int col = 5;
    // ignore: deprecated_member_use
    Stat.transac = List.generate(row, (i) => List(col));
    for(int i=0;i<acc.length-1;i++){
      Stat.transac[i] = acc[i].split("  ");
      for(int j =0;j<5;j++) {
        Stat.transac[i][j].trim();
      }
    }
  }
  @override
  void initState(){
    Future.delayed(Duration.zero,() async {
      var url2 = 'https://whospital123.000webhostapp.com/prj/getdoc.php';
      http.Response response2 = await http.get(Uri.parse(url2));
      String data2 = (response2.body).toString();
      List acc2;
      acc2 = data2.split("#");
      int row2 = acc2.length-1;
      int col2 = 5;
      // ignore: deprecated_member_use
      Stat.login = List.generate(row2, (i) => List(col2), growable: false);
      // ignore: deprecated_member_use
      Stat.pas = List<String>(row2);
      // ignore: deprecated_member_use
      Stat.balance = List<String>(row2);
      setState(() {
        for(int i=0;i<acc2.length-1;i++){
          Stat.login[i] = acc2[i].split("  ");
          Stat.pas[i] = Stat.login[i][1].toString().trim();
          Stat.balance[i] = Stat.login[i][4].toString().trim();
        }
      });
      var url = 'https://whospital123.000webhostapp.com/prj/getran.php';
      http.Response response = await http.post(Uri.parse(url),body: {
        'tname': Stat.login[Stat.usd][0]
      });
      String data = (response.body).toString();
      List acc;
      acc = data.split("#");
      int row = acc.length-1;
      int col = 5;
      // ignore: deprecated_member_use
      Stat.transac = List.generate(row, (i) => List(col));
      for(int i=0;i<acc.length-1;i++){
        Stat.transac[i] = acc[i].split("  ");
        for(int j =0;j<4;j++) {
          Stat.transac[i][j].trim();
        }
      }
    });
    Future(() {
      final _emailsnack = SnackBar(
        content: Text('Your Email Address was Changed!\n${Stat.login[Stat.usd][3]}',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label:'Undo',
          onPressed: () {
            setState(() {
              Stat.login[Stat.usd][3] = Stat.remail;
              updatene();
            });
          },
          textColor: Colors.blue[700],
        ),
      );
      if(Stat.ramail.compareTo("vmail")==0){
        ScaffoldMessenger.of(context).showSnackBar(_emailsnack);
        Stat.ramail = "";
        updatene();
      }
    });
    super.initState();
  }
  bool _secure = true;
  warnAlert(){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Warning!",
        desc: "Incorrect password!",
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

  Future<void> newAlert(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  scrollable: true,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                  title: Center(child: Text("Change Password")),
                  content: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Column(
                      children: [
                        Text("To change password you need to Enter the current password.",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        SizedBox(height: 8,),
                        Container(
                          height: 55,
                          child: TextField(
                            obscureText: _secure,
                            cursorHeight: 24,
                            controller: inp1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))
                              ),
                              labelText: 'Enter Current Password',
                              suffixIcon: IconButton(icon: Icon(
                                  _secure ? Icons.visibility_off_rounded : Icons
                                      .visibility_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _secure = !_secure;
                                    });
                                  }
                              ),
                            ),
                            autofocus: false,
                            style: TextStyle(
                              fontSize: 24,
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Center(
                        child: DialogButton(
                          child: Text("Confirm",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          color: Colors.purple,
                          onPressed: () {
                            setState(() {
                              if ((inp1.text.toString()).compareTo(
                                  Stat.pas[Stat.usd]) == 0) {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Pasword()));
                              }
                              else {
                                warnAlert();
                              }
                            });
                          },
                          width: 130,
                        )
                    ),

                  ],
                );
              }
          );
        });
  }

  TextEditingController inp1 = new TextEditingController();
  var inp2 = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: ',',leftSymbol: '₹',precision: 0);

  String acc = Stat.login[Stat.usd][0].toString();
  String name = Stat.login[Stat.usd][2].toString();
  String rname;

  Future<bool> _onWillPop() {
    return Alert(
        onWillPopActive: true,
        context: context,
        title: "Are you sure ?",
        desc: "Do you really want to Log Out.",
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
              Phoenix.rebirth(context);
            },
            width: 80,
          )
        ]
    ).show();
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
              setall();
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
                  setall();
                }
              });
            },
            width: 140,
          ),
        ]
    ).show();
  }

  warnAlertemail(String data){
    Alert(
        onWillPopActive: true,
        context: context,
        title: "Invalid Email address!",
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
              inp4.text = "";
              Navigator.pop(context);
            },
            width: 140,
          ),
        ]
    ).show();
  }
  @override
  Widget build(BuildContext context) {
    final _namesnack = SnackBar(
      content: Text('Your Name was Changed!',
        style: TextStyle(
            color: Colors.black
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label:'Undo',
        onPressed: () {
          setState(() {
            Stat.login[Stat.usd][2] = rname;
            updatene();
          });
        },
        textColor: Colors.blue[700],
      ),
    );

    changename(){
      Alert(
          context: context,
          onWillPopActive: true,
          title: 'Change Name',
          content: Container(
            height: 90,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
              child: TextField(
                cursorHeight: 29,
                controller: inp3,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                ],
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter New Name',
                ),
                autofocus: false,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          buttons: [
            DialogButton(
              child: Text("Confirm",
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
                      Navigator.pop(context);
                      rname = "";
                      rname = Stat.login[Stat.usd][2];
                      Stat.login[Stat.usd][2] = inp3.text.toString();
                      ScaffoldMessenger.of(context).showSnackBar(_namesnack);
                      updatene();
                    });
                  }
                });
              },
              width: 140,
            )
          ]
      ).show();
    }
    bool isEmail(String string) {
      if (EmailValidator.validate(string) != true) {
        warnAlertemail("This email address is not a valid input.");
        return false;
      }
      for(int i =0;i<Stat.login.length;i++){
        if(string.compareTo(Stat.login[i][3])==0){
          warnAlertemail("This email address is already exist.");
          return false;
        }
      }
      return true;
    }
    changeemail(){
      Alert(
          context: context,
          onWillPopActive: true,
          title: 'Change Email Address',
          content: Container(
            height: 90,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
              child: TextField(
                cursorHeight: 29,
                controller: inp4,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                ],
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter New Email Address',
                ),
                autofocus: false,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          buttons: [
            DialogButton(
              child: Text("Confirm",
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
                      Stat.remail = "";
                      Stat.remail = Stat.login[Stat.usd][3];
                      if(isEmail(inp4.text.toString())) {
                        Navigator.pop(context);
                        Stat.login[Stat.usd][3] = inp4.text.toString();
                        Stat.ramail = "vmail";
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Valid()));
                      }
                    });
                  }
                });
              },
              width: 140,
            )
          ]
      ).show();
    }

    profilepop() {
      Alert(
          onWillPopActive: true,
          context: context,
          title: "Profile",
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name:',
                      style: TextStyle(
                          color: Colors.grey[700]
                      ),
                    ),
                    IconButton(icon: Icon(Icons.edit), onPressed: () {
                      Navigator.pop(context);
                      inp3.text = "";
                      changename();
                    },
                      iconSize: 20,
                    )
                  ],
                ),
                Text('${Stat.login[Stat.usd][2]}'),
                Text('\nMobile Number:',
                  style: TextStyle(
                      color: Colors.grey[700]
                  ),
                ),
                SizedBox(height: 10,),
                Text('${Stat.login[Stat.usd][0]}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\nE-mail address:',
                      style: TextStyle(
                          color: Colors.grey[700]
                      ),
                    ),
                    IconButton(icon: Icon(Icons.edit), onPressed: () {
                      Navigator.pop(context);
                      inp4.text = "";
                      changeemail();
                    },
                        iconSize: 20)
                  ],
                ),
                SizedBox(height: 10,),
                Text('${Stat.login[Stat.usd][3]}')
              ],
            ),
          ),
          buttons: [
            DialogButton(
              child: Text("Close",
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
              width: 130,
            )
          ]
      ).show();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            brightness: Brightness.dark,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60.0),
                bottomRight:  Radius.circular(60.0),
              ),
            ),
            titleSpacing: 1.0,
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('   Hello 👋',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    PopupMenuButton(
                        icon: Icon(Icons.more_vert_rounded),
                        elevation: 20,
                        shape: ContinuousRectangleBorder(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(50.0),
                              bottomRight:  Radius.circular(50.0),
                              topLeft: Radius.circular(50.0)
                          ),
                        ),
                        enabled: true,
                        onSelected: (value) {
                          setState(() {
                            if(value == 1){
                              profilepop();
                            }
                            if(value == 2){
                              inp1.text ="";
                              Stat.page = "Change";
                              newAlert(context);
                            }
                            if(value == 3){
                              _onWillPop();
                            }
                          });
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Profile"),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text("Change Password"),
                            value: 2,
                          ),
                          PopupMenuItem(
                            child: Text("Log Out"),
                            value: 3,
                          )
                        ]
                    )
                  ],
                ),
              ],
            ),
            backgroundColor: Colors.purple,
            elevation: 10.0,
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(

          onPressed: () {
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Write()));
            });
          },
          label: Text('Prescription',
            style: TextStyle(
              fontSize: 20
            )
          ),
          icon: Icon(Icons.edit),
          backgroundColor: Colors.purple,
        ),
        body: RefreshIndicator(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child:Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30,),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[700],
                      radius: 65,
                      child: CircleAvatar(
                        backgroundColor: Colors.greenAccent[100],
                        radius: 60,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              "assets/mdoctor.png"),
                          radius: 60,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Text("Dr.${Stat.login[Stat.usd][2]}",
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),

                  // ignore: deprecated_member_use
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        )),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Transaction()));
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.inbox,
                                size: 25,
                              ),
                              Text(
                                " Prescription history",
                                style: TextStyle(

                                  fontSize: 26,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${Stat.transac.length}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 27,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Pending Requests",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade900
                    )
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Center(
                    child: Text("No requests found",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey
                        )
                    ),
                  ),
                ],
              ),
            ),

          ),
          onRefresh: () {
            icheck().then((intenet) {
              if ((intenet != null && intenet)!=true) {
                internetAlert();
              }
            });
            return Future.delayed(
              Duration.zero,
                  () async {
                var url2 = 'https://whospital123.000webhostapp.com/prj/getdoc.php';
                http.Response response2 = await http.get(Uri.parse(url2));
                String data2 = (response2.body).toString();
                List acc2;
                acc2 = data2.split("#");
                int row2 = acc2.length-1;
                int col2 = 5;
                // ignore: deprecated_member_use
                Stat.login = List.generate(row2, (i) => List(col2), growable: false);
                // ignore: deprecated_member_use
                Stat.pas = List<String>(row2);
                // ignore: deprecated_member_use
                Stat.balance = List<String>(row2);
                setState(() {
                  for(int i=0;i<acc2.length-1;i++){
                    Stat.login[i] = acc2[i].split("  ");
                    Stat.pas[i] = Stat.login[i][1].toString().trim();
                    Stat.balance[i] = Stat.login[i][4].toString().trim();
                  }
                });
                var url = 'https://whospital123.000webhostapp.com/prj/getran.php';
                http.Response response = await http.post(Uri.parse(url),body: {
                  'tname': Stat.login[Stat.usd][0]
                });
                String data = (response.body).toString();
                List acc;
                acc = data.split("#");
                int row = acc.length-1;
                int col = 4;
                // ignore: deprecated_member_use
                Stat.transac = List.generate(row, (i) => List(col));
                setState(() {
                  for(int i=0;i<acc.length-1;i++){
                    Stat.transac[i] = acc[i].split("  ");
                    for(int j =0;j<4;j++) {
                      Stat.transac[i][j].trim();
                    }
                  }
                  print(Stat.transac);
                  print(Stat.transac==null);
                });
              },
            );
          },
        ),
      ),
    );
  }
}



