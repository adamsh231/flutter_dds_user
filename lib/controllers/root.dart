import 'package:flutter/material.dart';
import 'package:stunting/controllers/auth.dart';
import '../views/login.dart';
import '../views/home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum SignStatus { signedIn, notSignedIn }

class Root extends StatefulWidget {
  Root({Key key, this.auth}) : super(key: key);

  final BaseAuth auth;

  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  SignStatus _isSign = SignStatus.notSignedIn;
  SharedPreferences _sharedPreferences;
  List _userData = new List();

  _saveData() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    String dataJson = json.encode(_userData);
    setState(() {
      _sharedPreferences.setString("dataUser", dataJson);
    });
  }

  _remove() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _sharedPreferences.remove("dataUser");
      _sharedPreferences.remove("dataChild");
    });
  }

  Future<List> _load() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      try{
        _userData = json.decode(_sharedPreferences.getString("dataUser") ?? null);
      }catch(e){
        print("Error: $e");
      }
    });
    return _userData;
  }

  @override
  void initState() {
    super.initState();
    _load().then((id) {
      if (id.isNotEmpty) {
        _isSign = SignStatus.signedIn;
      } else {
        _isSign = SignStatus.notSignedIn;
      }
    });
  }

  void _signedIn() {
    setState(() {
      _isSign = SignStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _remove();
      _isSign = SignStatus.notSignedIn;
    });
  }

  void _setUserData(List data) {
    setState(() {
      _userData = data;
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_isSign) {
      case SignStatus.notSignedIn:
        return Login(
          onSignedIn: _signedIn,
          auth: widget.auth,
          userData: _setUserData,
        );
      case SignStatus.signedIn:
        return Home(
          signedOut: _signedOut,
          userData: _userData,
        );
      default:
        return Login(
          onSignedIn: _signedIn,
          auth: widget.auth,
          userData: _setUserData,
        );
    }
  }
}
