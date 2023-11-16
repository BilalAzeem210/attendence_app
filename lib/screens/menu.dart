import 'dart:convert';

import 'package:essa_sales_tracking/screens/login.dart';
import 'package:essa_sales_tracking/screens/reports.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class Menu extends StatelessWidget {
  late String _userId;
  late String _moblieNo;
  double _latitude = 0.0;
  double _longitude = 0.0;
  Menu(String userId,String mobileNo){
    this._userId = userId;
    this._moblieNo = mobileNo;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple
                  .shade700,
            ),
              accountName: Text(_userId), accountEmail: Text(_moblieNo)),
          ListTile(leading: Icon(Icons.accessibility),
          title: Text("Profile")),
          const Divider(),
          InkWell(onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
              return Reports(_userId,_moblieNo);
            }));
          },
          child: ListTile(leading: Icon(Icons.report_problem_outlined),
              title: Text("Reports")),),
          const Divider(),
          InkWell(
              onTap: ()async{
                var widthSize = MediaQuery.of(context).size.width;
                var heightSize = MediaQuery.of(context).size.height * 0.7;
                Navigator.of(context).pop();
                showModalBottomSheet(context: context, builder: (ctx){
                  TextEditingController remarksController = TextEditingController();
                  return Container(
                    width: widthSize,
                    height: heightSize,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Remarks"
                          ),
                          maxLines: 5,
                          controller: remarksController,
                          onChanged: (val){
                            remarksController.text = val;
                          },
                        ),
                        const SizedBox(height: 5,),
                        ElevatedButton(onPressed: () async{
                          await _getLocation();
                          print("latitude : ${_latitude}");
                          print("longitude : ${_longitude}");
                          try {
                            DateTime date = DateTime.now();
                            Map<int, String> months = {1 : "JAN", 2 : "FEB", 3 : "MAR", 4 : "APR", 5 : "MAY",
                              6 : "JUN", 7 : "JUL", 8 : "AUG", 9 : "SEP", 10 : "OCT", 11 : "NOV",12 : "DEC"};
                            String isAMOrPM = date.hour < 12 ? "AM" : "PM";
                            var myDate = "${date.day}-${months[date.month]}-${date.year} ${date.hour}:${date.minute}:${date.second} $isAMOrPM";
                            print(myDate);
                            var response = await http.post(Uri.http("194.163.166.163:1251","/ords/sc_attendence/attn/attendence"),
                                headers: <String, String>{
                                  'Content-Type' : 'application/json'
                                },
                                body: jsonEncode(<String, dynamic>{
                                  "usrid" : _userId,
                                  "checktype" : "I",
                                  "gpslat" : _latitude,
                                  "gpslon" : _longitude,
                                  "remarks": remarksController.text
                                })
                            );
                            print("post ${response.statusCode}");
                            if(response.statusCode == 200){
                              print('Successfully: ${response.body.toString()}');
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Attendence successfully marked")));
                            }
                            else{
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text("Something went wrong in marking attendence")));
                            }
                            Navigator.of(ctx).pop();
                          }

                          catch(e){
                            print(e.toString());
                          }
                        }, child: Text("Mark attendence"))
                      ],
                    ),
                  );
                });
              },
              child: ListTile(leading:Icon(Icons.bookmark_added),
              title:Text("Mark Attendence"))),
          const Divider(),
          ListTile(leading: Icon(Icons.gps_fixed),
              title:Text("Switch GPS")),
          const Divider(),
          ListTile(leading: Icon(Icons.data_saver_off_rounded),
              title:Text("Save Coordinates")),
          const Divider(),
          InkWell(child: ListTile(leading: Icon(Icons.logout_rounded),
              title:Text("Logout")), onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
              return LoginScreen();
            }));
          },),
        ],
      )
    );
  }
  Future<void> _getLocation() async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    _latitude = locationData.latitude!;
    _longitude = locationData.longitude!;
  }
}
