import 'package:flutter/material.dart';
import 'package:stunting/controllers/auth.dart';
import './controllers/root.dart';

void main(){
  runApp(Stunting());
}

class Stunting extends StatelessWidget {
  const Stunting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Stunting",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Root(auth: Auth(),),
    );
  }
}