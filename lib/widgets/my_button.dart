import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  late String _buttonText;
  late Function _onTap;
  MyButton(String buttonText, Function onTap){
    this._buttonText = buttonText;
    this._onTap = onTap;
  }

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        _isLoading = true;
        setState(() {

        });
        String response = await widget._onTap();
        if(response == "Login failed"){
          _isLoading = false;

        }
      },
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.green
        ),
        child: _isLoading ? const Center(child: CircularProgressIndicator()) : Center(child: Text(widget._buttonText)),
      ),
    );
  }
}
