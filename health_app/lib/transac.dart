import 'package:flutter/material.dart';
import 'package:health_app/vstatic.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
  home: Transaction(),
  debugShowCheckedModeBanner: false,
));

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}


class _TransactionState extends State<Transaction> {
  _call(int i) async{
    var url = 'tel:${Stat.transac[i][1]}';
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
        height: 280,
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
                      Text("${Stat.transac[i][0]}",
                        style: TextStyle(
                            fontSize: 24
                        ),
                      ),
                      Text("${Stat.transac[i][1]}")
                    ],
                  ),
                  IconButton(icon: Icon(Icons.call), onPressed: () {
                    setState(() {
                      _call(i);
                    });
                  },),
                ],
              ),
              SizedBox(height: 8,),
              Text("Prescription:",
                style: TextStyle(
                  fontSize: 24
                ),
              ),
              SizedBox(height: 8,),
              Container(
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[200],
                        offset: Offset(0,0),
                        blurRadius: 3.0)
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.vertical,
                      child: Container(child: Text("${Stat.transac[i][3]}"))),
                ),
              ),
              SizedBox(height: 10,),
              Text("${Stat.transac[i][2]}",
                style: TextStyle(
                    fontSize: 15
                ),
              )
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
          title: Text('Prescription History',
            style: TextStyle(
                fontSize: 20
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
            SizedBox(height: 30,),
            for(int i=Stat.transac.length-1;i>=0;i--) createCont(i),
            SizedBox(height: 150,)
          ],
        ),
      ),
    );
  }
}
