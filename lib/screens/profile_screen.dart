import 'dart:convert';

import 'package:essa_sales_tracking/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  late String _userId;
  late String _mobileNo;
  ProfileScreen(String userId, String mobileNo){
    this._userId = userId;
    this._mobileNo = mobileNo;
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: const Text("Sales tracking")
      ),
      drawer: Menu(widget._userId,widget._mobileNo),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: FutureBuilder<Map<String, dynamic>?>(
          builder: (ctx, snapshot){
            if(snapshot.hasData && snapshot.data != null){
              Map<String, dynamic> data = snapshot.data!;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenSize.height * 0.07),
                    Container(
                        width: screenSize.width,
                        alignment: Alignment.center,
                        child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.green
                        )
                    ),
                    const SizedBox(height: 5),
                    Expanded(child: ListView(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Name"),
                                    trailing: Text(data["empname"])
                                )
                            )
                        )),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Department"),
                                    trailing: Text(data["dptname"])
                                )
                            )
                        )),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Designation"),
                                    trailing: Text(data["dsgdsc"])
                                )
                            )
                        )),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Mobile no"),
                                    trailing: Text(widget._mobileNo)
                                ),
                            ),
                        ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Present"),
                                    trailing: Text(data["c_present"].toString())
                                ),
                            ),
                        ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Rest"),
                                    trailing: Text(data["c_rest"].toString())
                                )
                            )
                        )),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Absent"),
                                    trailing: Text(data["c_absent"].toString())
                                )
                            )
                        )),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Leave"),
                                    trailing: Text(data["c_leave"].toString())
                                ),
                            ),
                        ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Late"),
                                    trailing: Text(data["c_latein"].toString())
                                )
                            )
                        )),
                        Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                            elevation: 5,
                            child: Container(
                                width: screenSize.width,
                                child: ListTile(
                                    leading: const Text("Over time"),
                                    trailing: Text(data["t_ovthrs"].toString())
                                )
                            )
                        )),
                        ],
                    ),
                    ),
                  ],
              );
            }
            return const Center(
              child: CircularProgressIndicator()
            );
          },
          future: _dataFuture
        )
      )
    );
  }
  Future<Map<String, dynamic>?> _fetchData() async{
    try{
      var response = await http.get(Uri.http("194.163.166.163:1251","/ords/sc_attendence/attn/employee_info",{"usrid" : widget._userId, "monid" : "202107"}));
      int statusCode = response.statusCode;
      print(statusCode);
      if(statusCode == 200){
        var data = jsonDecode(response.body);
        print("data : ${data["items"][0]}");
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
