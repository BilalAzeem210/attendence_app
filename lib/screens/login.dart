import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:essa_sales_tracking/screens/profile_screen.dart';
import 'package:essa_sales_tracking/widgets/my_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _password = "";
  String _hintText = "";
  bool _firstTimeLogin = false;
  var _formKey = GlobalKey<FormState>();
  String _mobileNumber = '';
  var sharedPreference;
  ValueNotifier<bool> _loginListen = ValueNotifier<bool>(true);
  var _deviceToken;

  var _dbExistence;

  var _isFirsttime;
  Future<bool> _checkDbExistence() async{
    print("checking db existence");
    /*try{
      String directoryPath = (await getExternalStorageDirectory())!.path;
      String documentsPath = directoryPath.substring(0, directoryPath.indexOf("/data"));
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if(status.isGranted){
        Directory dir = await Directory(documentsPath + "/mytestdatabase");
        print("dir PATH ${dir.path}");
        if(await dir.exists()){
          print("dir exists");
          if(await databaseExists(documentsPath + "/mytestdatabase/testing.db")) {
            print("database exists");
            _database = await openDatabase("${dir.path}/testing.db");
          }
          else{
            _database = await openDatabase("${dir.path}/testing.db",onCreate: (db, version) async{
              await db.execute('CREATE TABLE Test (devicetoken INTEGER PRIMARY KEY, mobileNo TEXT)');
              print("database created");
            });
            print("database : ${database}");
          }
          return true;
        }
        else{
          print("creating dir");
          dir = await dir.create(recursive: true);
          print("directory created");
          _database = await openDatabase("${dir.path}/testing.db", version: 1,onCreate: (db, version) async{
            await db.execute('CREATE TABLE Test (devicetoken INTEGER PRIMARY KEY, mobileNo TEXT)');
            print("database created");
          });
          return true;
        }
      }
      else{
        return false;
      }
    }
    catch(e){
      print("error in db existence");
    }
    return false;*/
   sharedPreference = (await SharedPreferences.getInstance());
   var token = sharedPreference.getString("deviceToken");
   if(token != null){
     print("sh token : ${token}");
     // bind data
     _hintText = sharedPreference.getString("mobileNo");
     _email = _hintText;
     _deviceToken = token;
     return false;
   }
   else{
     print("first time login");
     return true;
   }
  }
  @override
  void initState() {
    Future.delayed(Duration.zero, () async{
      _dbExistence = await _checkDbExistence();
      if(_dbExistence){
        //first time
        _isFirsttime = true;
      }
      else{
        // not first time
        _isFirsttime = false;
        print("deviceToken from local db : ${_deviceToken}");
        setState(() {

        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(5), child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_android),
                    hintText: _hintText.isEmpty ? "Mobile no" : _hintText,
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (_email.isEmpty) {
                      return "Invalid mobile no";
                    }
                    return null;
                  },
                  onSaved: (val){
                    if(_isFirsttime){
                      print("first save");
                      _email = val!;
                    }
                  },
                  keyboardType: TextInputType.phone,
                )
            )),
            Padding(padding: const EdgeInsets.all(5),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.password_sharp),
                          hintText: "password"
                      ),
                      validator: (val) {
                        if (val!.length < 2) {
                          return "Invalid password address";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _password = val!;
                      },
                    )
                )
            ),
            const SizedBox(height: 10,),
            //MyButton("Login", _validateUser)
        ValueListenableBuilder<bool>(valueListenable: _loginListen, builder: (ctx, value, ch){
          if(value){
            return InkWell(
              onTap: _validateUser,
              child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green
                  ),
                  child: const Center(child: Center(child: Text("Login")),
          )),
            );
          }
          else{
            Timer(const Duration(seconds: 2), (){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login failed")));
              _loginListen.value = true;
            });
            return InkWell(
              onTap: _validateUser,
              child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green
                  ),
                  child: const Center(child: Center(child: CircularProgressIndicator()),
                  )),
            );
          }
        })

            /*ElevatedButton(onPressed: (){
              _validateUser();
            },
            child: Text("Login")
            )*/
          ],
        ),
      ),
    );
  }

  Future<String> _validateUser() async {
    var currentState = _formKey.currentState!;
    currentState.save();
    bool isValid = currentState.validate();
    print("valid : ${isValid}");
    if (isValid) {
      print("validate user");
      try {
        if(_isFirsttime){
          // firsttime login
          String? deviceToken = Uuid().v1() + DateTime.now().toString();
          print("token : ${deviceToken}");
          print("sending req");
          Uri uri = Uri.http("194.163.166.163:1251", "/ords/sc_attendence/attn/login",
              {"empmobile": _email, "password": _password, "tokenid" : null});
          var response = await http.get(uri);
          print(response.statusCode);
          var res = jsonDecode(response.body);
          print(res["items"]);
          if(response.statusCode == 200){
            var empId = res["items"][0]["usrid"];
            var deviceTokenResponse = await http.put(
              Uri.http("194.163.166.163:1251", "/ords/sc_attendence/attn/token"),
              body: jsonEncode({
                "usrid": empId,
                "tokenid": deviceToken
              }),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
            );
            print("first put status : ${deviceTokenResponse.statusCode}");
            if(deviceTokenResponse.statusCode == 200){
              await sharedPreference.setString("deviceToken", deviceToken);
              await sharedPreference.setString("mobileNo", _email);
              print("data successfully inserted");
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) {
                    return ProfileScreen(res["items"][0]["usrid"], "");
                  }));
              return "Login successful";
            }
          }
          _loginListen.value = false;
          return "Login failed";
        }
        else{
          print("not firsttime");
          print("dev tok : ${_deviceToken}");
          print("pass : ${_password}");
          print("mob : ${_hintText}");
          // not firsttime login
          Uri uri = Uri.http("194.163.166.163:1251", "/ords/sc_attendence/attn/login",
              {"empmobile": _hintText, "password": _password, "tokenid" : _deviceToken});
          var response = await http.get(uri);
          print(response.statusCode);
          var res = jsonDecode(response.body);
          print(res["items"]);
          if(response.statusCode == 200 && res["items"].length > 0){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) {
                  return ProfileScreen(res["items"][0]["usrid"], "");
                }));
          }
          else{
            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed")));
            _loginListen.value = false;
            return "Login failed";
          }
          return "Login successful";
        }
      }
      catch(e){
        print("error");
        print(e.toString());
        _loginListen.value = false;
        return "Login failed";
      }
    }
    _loginListen.value = false;
    return "Login failed";
  }


}