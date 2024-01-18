import 'dart:convert';

import 'package:essa_sales_tracking/screens/login.dart';
import 'package:essa_sales_tracking/screens/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class Menu extends StatelessWidget {
  late String _userId;
  late String _moblieNo;
  double _latitude = 0.0;
  double _longitude = 0.0;

  ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(true);
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
          const ListTile(leading: Icon(Icons.accessibility),
          title: Text("Profile")),
          const Divider(),
          InkWell(onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
              return Reports(_userId,_moblieNo);
            }));
          },
          child: const ListTile(leading: Icon(Icons.report_problem_outlined),
              title: Text("Reports")),),
          const Divider(),
          InkWell(
              onTap: ()async{
                var widthSize = MediaQuery.of(context).size.width;
                var heightSize = MediaQuery.of(context).size.height * 0.7;
                Navigator.of(context).pop();
                showModalBottomSheet(context: context, builder: (ctx){
                  TextEditingController remarksController = TextEditingController();
                  return SizedBox(
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
                        ValueListenableBuilder(
                          valueListenable: _isButtonEnabled,
                          builder: (context, value, ch) {
                            if(value){
                              return ElevatedButton(onPressed: () async{
                                _isButtonEnabled.value = false;
                              if(await _getLocationAndClearCache()) {
                                print("latitude : $_latitude");
                                print("longitude : $_longitude");
                                try {
                                  DateTime date = DateTime.now();
                                  Map<int, String> months = {
                                    1: "JAN",
                                    2: "FEB",
                                    3: "MAR",
                                    4: "APR",
                                    5: "MAY",
                                    6: "JUN",
                                    7: "JUL",
                                    8: "AUG",
                                    9: "SEP",
                                    10: "OCT",
                                    11: "NOV",
                                    12: "DEC"
                                  };
                                  String isAMOrPM = date.hour < 12 ? "AM" : "PM";
                                  var myDate = "${date.day}-${months[date
                                      .month]}-${date.year} ${date.hour}:${date
                                      .minute}:${date.second} $isAMOrPM";
                                  print(myDate);
                                  var response = await http.post(Uri.http(
                                      "194.163.166.163:1251",
                                      "/ords/sc_attendence/attn/attendence"),
                                      headers: <String, String>{
                                        'Content-Type': 'application/json'
                                      },
                                      body: jsonEncode(<String, dynamic>{
                                        "usrid": _userId,
                                        "checktype": "I",
                                        "gpslat": _latitude,
                                        "gpslon": _longitude,
                                        "remarks": remarksController.text
                                      })
                                  );
                                  print("post ${response.statusCode}");
                                  if (response.statusCode == 200) {
                                    print('Successfully: ${response.body
                                        .toString()}');
                                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                                        content: Text("Attendence successfully marked")));
                                  }
                                  else {
                                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                                        content: Text(
                                            "Something went wrong in marking attendence")));
                                  }
                                  Navigator.of(ctx).pop();
                                }

                                catch (e) {
                                  print(e.toString());
                                }
                              }
                              else{
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text("Please open your location")));
                              }
                              _isButtonEnabled.value = true;
                            }, child: const Text("Mark attendence"));
                            }
                            return const ElevatedButton(onPressed: null, child: Text("Mark attendence"));
                          }
                        )
                      ],
                    ),
                  );
                });
              },
              child: const ListTile(leading:Icon(Icons.bookmark_added),
              title:Text("Mark Attendence"))),
          const Divider(),
          const ListTile(leading: Icon(Icons.gps_fixed),
              title:Text("Switch GPS")),
          const Divider(),
          const ListTile(leading: Icon(Icons.data_saver_off_rounded),
              title:Text("Save Coordinates")),
          const Divider(),
          InkWell(child: const ListTile(leading: Icon(Icons.logout_rounded),
              title:Text("Logout")), onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
              return const LoginScreen();
            }));
          },),
        ],
      )
    );
  }
  Future<bool> _getLocationAndClearCache() async{
    DefaultCacheManager cacheManager = DefaultCacheManager();
    await cacheManager.emptyCache();
    cacheManager.store.emptyMemoryCache();
    print("cache: ${cacheManager.store.lastCleanupRun}");
    print("cacheStr: ${cacheManager.store.toString()}");
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    /*LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    location.changeSettings(accuracy: LocationAccuracy.high);
    locationData = await location.getLocation();*/
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("serviceEnabled: ${serviceEnabled}");
    if (!serviceEnabled) {
      print("requesting permission");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    if(!serviceEnabled){
      print("requesting permission again");
      permission = await Geolocator.requestPermission();
      //return false;
    }
    try {
      Position locationData = await Geolocator.getCurrentPosition();
      _latitude = locationData.latitude;
      _longitude = locationData.longitude;
      print("lat: $_latitude");
      print("lon: $_longitude");
    }
    catch(e){
      return false;
    }
      return true;
    }
  }

