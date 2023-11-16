import 'dart:convert';

import 'package:essa_sales_tracking/screens/reports.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendanceScreen extends StatefulWidget {
  late String _userId;
  late String _mobileNo;
  AttendanceScreen(String userId,String mobileNo ){
    this._userId = userId;
    this._mobileNo = mobileNo;
  }
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
            return Reports(widget._userId,widget._mobileNo);
          })),
        ),
      ),

      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5), child: Card(
              elevation: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                      leading: Text("Days"),
                      trailing: Text('30'),
                  )
              )
          )),
          Padding(padding: EdgeInsets.all(5), child: Card(
              elevation: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                      leading: Text("Present"),
                      trailing: Text('27'),
                  )
              )
          )),
          Padding(padding: EdgeInsets.all(5), child: Card(
              elevation: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                      leading: Text("Absent"),
                      trailing: Text('2')
                  )
              )
          )),
          Padding(padding: EdgeInsets.all(5), child: Card(
              elevation: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                      leading: Text("Leave"),
                      trailing: Text('2')
                  )
              )
          )),
          Padding(padding: EdgeInsets.all(5), child: Card(
              elevation: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                      leading: Text("Late"),
                      trailing: Text('3')
                  )
              )
          )),
          Padding(padding: EdgeInsets.all(5), child: Card(
              elevation: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                      leading: Text("OverTime"),
                      trailing: Text('10')
                  )
              )
          )),
          Padding(padding: EdgeInsets.all(5), child: Card(
              elevation: 5,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                      leading: Text("Short Hours"),
                      trailing: Text('5')
                  )
              )
          )),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: (){_getAttendence("I",24.8692,67.0847);}, child: Text('Enter Record')),
           ],
      )
      ),
    );
  }
  Future<String?> _getAttendence(String checkType,double lat,double long) async{
    print(widget._userId);
    print(widget._mobileNo);
    print(DateTime.now().toString());
    try {
      var response = await http.post(Uri.http("194.163.166.163:1251","/ords/hr_atn/attn/attendence"),
      headers: <String, String>{
        'Content-Type' : 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "usrid" : widget._userId,
        "mobileno" : widget._mobileNo,
        "checktype" : "I",
        "gpslat" : lat,
        "gpslon" : long
      })
      );
      print("post ${response.statusCode}");
      if(response.statusCode == 200){
        print('Successfully: ${response.body.toString()}');
        return "Successfully Added";

      }
    }

    catch(e){
      print(e.toString());
    }
    return null;
  }
}
