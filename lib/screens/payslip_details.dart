import 'dart:convert';

import 'package:essa_sales_tracking/screens/payslip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PayslipDetails extends StatefulWidget {
  late String _userId;
  late String _mobileNo;
  PayslipDetails(String userId,String mobileNo){
    this._userId = userId;
    this._mobileNo = mobileNo;
  }

  @override
  State<PayslipDetails> createState() => _PayslipDetailsState();
}

class _PayslipDetailsState extends State<PayslipDetails> {
  late Future<List<dynamic>?> _dataFuture;
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
        title: const Text("Sales tracking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
            return PaySlipScreen(widget._userId,widget._mobileNo);
          })),
        ),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: FutureBuilder<List<dynamic>?>(
          future: _dataFuture,
          builder: (ctx, snapshot){
            if(snapshot.hasData && snapshot.data != null){
              List<dynamic> data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (ctx, position){
                  return Expanded(
                    flex: 1,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Text("Pay id"),
                            trailing: Text(data[position]["payid"]),
                          ),
                          ListTile(
                            leading: const Text("Pay type"),
                            trailing: Text(data[position]["paytyp"]),
                          ),
                          ListTile(
                            leading: const Text("Pay head"),
                            trailing: Text(data[position]["payhead"]),
                          ),
                          ListTile(
                            leading: const Text("Amt grs"),
                            trailing: Text(data[position]["amtgrs"].toString()),
                          ),
                          ListTile(
                            leading: const Text("Amt act"),
                            trailing: Text(data[position]["amtact"].toString()),
                          ),
                        ],
                      )
                    ),
                  );
                }
              );
            }
            return const Center(
              child: CircularProgressIndicator()
            );
          },
        )
      )
    );
  }
  Future<List<dynamic>?> _fetchData() async{
    try{
      var response = await http.get(Uri.http("194.163.166.163:1251","/ords/sc_attendence/attn/payslip_d",{"usrid" : widget._userId, "monid" : "202107"}));
      int statusCode = response.statusCode;
      print(statusCode);
      if(statusCode == 200){
        var data = jsonDecode(response.body);
        print("payslip details data : ${data["items"]}");
        return  data["items"].length > 0 ? data["items"] : null;
      }
      return null;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}
