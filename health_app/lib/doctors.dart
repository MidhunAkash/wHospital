import 'package:flutter/material.dart';
import 'package:health_app/vstatic.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
  home: Doctors(),
  debugShowCheckedModeBanner: false,
));

class Doctors extends StatefulWidget {
  const Doctors({Key key}) : super(key: key);

  @override
  _DoctorsState createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {

  _sendingMails(int i) async {
    var url = 'mailto:${Stat.dlogin[i][3]}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _call(int i) async{
    var url = 'tel:${Stat.dlogin[i][0]}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  String name,acc,time,st;
  int rs;
  createCont(int i){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                offset: Offset(0,0),
                blurRadius: 3.0)
          ],

        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dr.${Stat.dlogin[i][2]}",
                        style: TextStyle(
                            fontSize: 24
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: 200,
                        child: FittedBox(
                          child: Text("${Stat.dlogin[i][4]}",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.mail), onPressed: () {
                        setState(() {
                          _sendingMails(i);
                        });
                      },),
                      IconButton(icon: Icon(Icons.call), onPressed: () {
                        setState(() {
                          _call(i);
                        });
                      },),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
              bottomLeft: Radius.circular(70.0),
              bottomRight: Radius.circular(70.0),
            ),
          ),
          title: Text('Doctors',
            style: TextStyle(
                fontSize: 25
            ),
          ),
          backgroundColor: Colors.purple,
          elevation: 10.0,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 25,),
            for(int i=Stat.dlogin.length-1;i>=0;i--) createCont(i),
            SizedBox(height: 150,)
          ],
        ),
      ),
    );
  }
}


