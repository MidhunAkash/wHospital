import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:health_app/doctors.dart';
import 'package:health_app/password.dart';
import 'package:health_app/transac.dart';
import 'package:health_app/validation.dart';
import 'package:health_app/vstatic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:connectivity/connectivity.dart';


void main() => runApp(const MaterialApp(
  home: Account(),
  debugShowCheckedModeBanner: false,
));

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController inp3 = TextEditingController();
  TextEditingController inp4 = TextEditingController();

  String rname;
  Future updatene() async{
    var url = 'https://whospital123.000webhostapp.com/prj/updatene.php';
    await http.post(Uri.parse(url),body: {
      'user': Stat.login[Stat.usd][0],
      'name': Stat.login[Stat.usd][2],
      'email': Stat.login[Stat.usd][3]
    });
  }
  Future setall() async{
    var url2 = 'https://whospital123.000webhostapp.com/prj/getacc.php';
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
      for(int j =0;j<5;j++) {
        Stat.transac[i][j].trim();
      }
    }
  }
  @override
  void initState(){
    Future.delayed(Duration.zero,() async {
      var url2 = 'https://whospital123.000webhostapp.com/prj/getacc.php';
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
          style: const TextStyle(
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

  Future<void> newAlert(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  scrollable: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  title: const Center(child: Text("Change Password")),
                  content: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Column(
                      children: [
                        const Text("To change password you need to Enter the current password.",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        const SizedBox(height: 8,),
                        SizedBox(
                          height: 55,
                          child: TextField(
                            obscureText: _secure,
                            cursorHeight: 24,
                            controller: inp1,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
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
                            style: const TextStyle(
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
                          child: const Text("Confirm",
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

  TextEditingController inp1 = TextEditingController();



  Future<bool> _onWillPop() {
    return Alert(
        onWillPopActive: true,
        context: context,
        title: "Are you sure ?",
        desc: "Do you really want to Log Out.",
        type: AlertType.none,
        closeIcon: const Icon(Icons.close),
        buttons: [
          DialogButton(
            child: const Text("No",
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
            child: const Text("Yes",
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
        closeIcon: IconButton(icon: const Icon(Icons.close),onPressed:(){
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
        desc: data,
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
      content: const Text('Your Name was Changed!',
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
          content: SizedBox(
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
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter New Name',
                ),
                autofocus: false,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
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
          content: SizedBox(
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
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter New Email Address',
                ),
                autofocus: false,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
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
          content: Column(
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
                  IconButton(icon: const Icon(Icons.edit), onPressed: () {
                    Navigator.pop(context);
                    inp3.text = "";
                    changename();
                  },
                    iconSize: 20,
                  )
                ],
              ),
              Text('${Stat.login[Stat.usd][2]}'),
              Text('\nRegistration Number:',
                style: TextStyle(
                    color: Colors.grey[700]
                ),
              ),
              const SizedBox(height: 10,),
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
              const SizedBox(height: 10,),
              Text('${Stat.login[Stat.usd][3]}')
            ],
          ),
          buttons: [
            DialogButton(
              child: const Text("Close",
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
                    const Text('   Hello 👋',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    PopupMenuButton(
                        icon: const Icon(Icons.more_vert_rounded),
                        elevation: 20,
                        shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.only(
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
                          const PopupMenuItem(
                            child: Text("Profile"),
                            value: 1,
                          ),
                          const PopupMenuItem(
                            child: Text("Change Password"),
                            value: 2,
                          ),
                          const PopupMenuItem(
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
        body: RefreshIndicator(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child:Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 25, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30,),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 60,
                      child: CircleAvatar(
                        backgroundColor: Colors.greenAccent[100],
                        radius: 55,
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                              "assets/sprofile.png"),
                          radius: 55,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Center(
                    child: Text("${Stat.login[Stat.usd][2]}",
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
                                " Prescriptions",
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
                  Text("Upcoming meets",
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
                    child: Text("No upcoming meets",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Scheduled Requests",
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
                    child: Text("No scheduled requests",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Schedule",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade900
                          )
                      ),
                      TextButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Doctors()));
                      }, child: Text("see all",
                        style: TextStyle(
                          fontSize: 15
                        )
                      ))
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(0,0),
                              blurRadius: 3.0)
                        ],),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 20,
                                child: CircleAvatar(
                                  radius: 15,
                                  child: const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/mdoctor.png"),
                                    radius: 15,
                                  ),
                                ),
                              ),
                              Text(
                                " Dr.Malli",
                                style: TextStyle(

                                  fontSize: 26,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.star_border_outlined,
                            size: 35,
                            color: Colors.grey,
                          )
                        ],
                      ),
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
                var url2 = 'https://whospital123.000webhostapp.com/prj/getacc.php';
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
                });
                var url3 = 'https://whospital123.000webhostapp.com/prj/getdoc.php';
                http.Response response3 = await http.get(Uri.parse(url3));
                String data3 = (response3.body).toString();
                List acc3;
                acc3 = data3.split("#");
                int row3 = acc3.length-1;
                int col3 = 5;
                // ignore: deprecated_member_use
                Stat.dlogin = List.generate(row3, (i) => List(col3), growable: false);
                setState(() {
                  for(int i=0;i<acc3.length-1;i++){
                    Stat.dlogin[i] = acc3[i].split("  ");
                  }
                });
                print(Stat.transac);
                print(Stat.transac==null);
              },
            );
          },
        ),
      ),
    );
  }
}



