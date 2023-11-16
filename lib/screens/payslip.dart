import 'dart:convert';

import 'package:essa_sales_tracking/screens/payslip_details.dart';
import 'package:essa_sales_tracking/screens/reports.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaySlipScreen extends StatefulWidget {
  late String _userId;
  late String _mobileNo;
  PaySlipScreen(String userId,String mobileNo){
    this._userId = userId;
    this._mobileNo = mobileNo;
  }

  @override
  State<PaySlipScreen> createState() => _PaySlipScreenState();
}

class _PaySlipScreenState extends State<PaySlipScreen> {
  late Future<Map<String, dynamic>?> _dataFuture;
  @override
  void initState() {
    // TODO: implement initState
    _dataFuture = _fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales tracking"),
          leading: IconButton(
      icon: const Icon(Icons.arrow_back,),
      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
        return Reports(widget._userId,widget._mobileNo);
      })),
    ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _dataFuture,
        builder: (ctx, snapshot){
          if(snapshot.hasData && snapshot.data != null){
            Map<String, dynamic> data = snapshot.data!;
            return SingleChildScrollView(child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Name"),
                            trailing: Text(data["empname"])
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Father name"),
                            trailing: Text(data["fthname"])
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Gender"),
                            trailing: Text(data["gender"])
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Birthday"),
                            trailing: Text(data["birthdt"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Join date"),
                            trailing: Text(data["joindt"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("CNIC no"),
                            trailing: Text(data["cnic"])
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Current days"),
                            trailing: Text(data["c_days"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Current days pay"),
                            trailing: Text(data["c_days_pay"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Current late in"),
                            trailing: Text(data["c_latein"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Current early out"),
                            trailing: Text(data["c_earlyout"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Present"),
                            trailing: Text(data["c_present"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Rest"),
                            trailing: Text(data["c_rest"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Absent"),
                            trailing: Text(data["c_absent"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Half day"),
                            trailing: Text(data["c_halfday"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Holiday"),
                            trailing: Text(data["c_holiday"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: const Text("Leave"),
                            trailing: Text(data["c_leave"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Total hours work"),
                            trailing: Text(data["t_hrswrk"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Total short hours"),
                            trailing: Text(data["t_shrhrs"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Total overtime hours"),
                            trailing: Text(data["t_ovthrs"].toString())
                        )
                    )
                )),
                Padding(padding: EdgeInsets.all(5), child: Card(
                    elevation: 5,
                    child: Container(
                        width: screenSize.width,
                        child: ListTile(
                            leading: Text("Employee type"),
                            trailing: Text(data["emptypdsc"])
                        )
                    )
                )),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx){
                      return PayslipDetails(widget._userId,widget._mobileNo);
                    }
                  ));
                }, child: Text("Details"))
              ],
            )
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
  Future<Map<String, dynamic>?> _fetchData() async{
    try{
      var response = await http.get(Uri.http("194.163.166.163:1251","/ords/sc_attendence/attn/payslip",{"usrid" : widget._userId, "monid" : "202107"}));
      int statusCode = response.statusCode;
      print(statusCode);
      if(statusCode == 200){
        var data = jsonDecode(response.body);
        print("payslip data : ${data["items"][0]}");
        return data["items"][0];
      }
      return null;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}
