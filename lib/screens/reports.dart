import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:essa_sales_tracking/screens/attendance_screen.dart';
import 'package:essa_sales_tracking/screens/payslip.dart';
import 'package:essa_sales_tracking/screens/profile_screen.dart';
import 'package:flutter/material.dart';


class Reports extends StatelessWidget {

  late String _userId;
  late String _mobileNo;
  Reports(String userId,String mobileNo){
    this._userId = userId;
    this._mobileNo = mobileNo;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales tracking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
            return ProfileScreen(_userId,_mobileNo );
          })),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: (){
            },
            child: const ListTile(leading: Text("Attendence"))
          ),
          InkWell(
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                  return PaySlipScreen(_userId,_mobileNo);
                }));
              },
              child: const ListTile(leading: Text("Pay slip"))
          ),
          InkWell(
              onTap: (){

              },
              child: const ListTile(leading: Text("Leave status"))
          ),
          InkWell(
              onTap: (){

              },
              child: const ListTile(leading: Text("Loan status"))
          ),
        ]
      )
    );
  }
}
