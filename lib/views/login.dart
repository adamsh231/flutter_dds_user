import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:stunting/controllers/auth.dart';

class Login extends StatefulWidget {
  Login({Key key, this.onSignedIn, this.auth, this.userData})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final ValueSetter<List> userData;

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _username, _password;
  bool _passwordVisible = true, _isLoading = false, _isLoginFail = false;
  List _userData;

  final _formKey = GlobalKey<FormState>();

  double _flexHeight(BuildContext context, double height) {
    return (MediaQuery.of(context).size.height * height / 774.8571428571429);
  }

  double _flexWidth(BuildContext context, double width) {
    return (MediaQuery.of(context).size.width * width / 411.42857142857144);
  }

  void _isVisible() {
    setState(() {
      if (_passwordVisible) {
        _passwordVisible = false;
      } else {
        _passwordVisible = true;
      }
    });
  }

  bool _submitAndValidate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future _submitAndAuth() async {
    if (_submitAndValidate()) {
      setState(() {
        _isLoading = true;
      });
      _userData =
          await widget.auth.logIn(email: _username, password: _password);
      if (_userData.length != 0) {
        setState(() {
          _isLoginFail = false;
        });
        widget.userData(_userData);
        widget.onSignedIn();
      } else {
        setState(() {
          _isLoginFail = true;
        });
      }
    } else {
      setState(() {
        _isLoginFail = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
    // print(_userData[0]['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("img/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Builder(
          builder: (BuildContext context) {
            return ModalProgressHUD(
              child: body(context),
              inAsyncCall: _isLoading,
            );
          },
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Colors.white,
            height: _flexHeight(context, 420),
            width: _flexWidth(context, 350),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Divider(
                    height: _flexHeight(context, 30),
                    color: Colors.black,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: _flexHeight(context, 20),
                        ),
                        TextFormField(
                          validator: (value) =>
                              value.isEmpty ? "Username kosong!" : null,
                          decoration: InputDecoration(
                            errorBorder: _errorInputBorder,
                            focusedErrorBorder: _errorInputBorder,
                            enabledBorder: _validInputBorder,
                            focusedBorder: _validInputBorder,
                            labelText: "Username",
                          ),
                          onSaved: (value) => _username = value,
                        ),
                        SizedBox(
                          height: _flexHeight(context, 20),
                        ),
                        TextFormField(
                          obscureText: _passwordVisible,
                          validator: (value) =>
                              value.isEmpty ? "Password kosong!" : null,
                          decoration: InputDecoration(
                            errorBorder: _errorInputBorder,
                            focusedErrorBorder: _errorInputBorder,
                            enabledBorder: _validInputBorder,
                            focusedBorder: _validInputBorder,
                            suffixIcon: IconButton(
                              icon: _passwordVisible
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: _isVisible,
                            ),
                            labelText: "Password",
                          ),
                          onSaved: (value) => _password = value,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _flexHeight(context, 20),
                  ),
                  ButtonTheme(
                    height: _flexHeight(context, 50),
                    minWidth: _flexWidth(context, 200),
                    child: RaisedButton(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      color: Color.fromRGBO(78, 115, 222, 1),
                      focusColor: Color.fromRGBO(78, 115, 222, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () async {
                        await _submitAndAuth();
                        if (_isLoginFail) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Login Gagal !"),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final _errorInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 1.5,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(30),
  );

  final _validInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.indigo,
      width: 1.5,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(30),
  );
}
