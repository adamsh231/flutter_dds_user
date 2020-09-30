import 'package:flutter/material.dart';
import './widget/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'child.dart';
import '../controllers/exctract.dart';

class Home extends StatefulWidget {
  Home({Key key, this.signedOut, this.userData}) : super(key: key);

  final VoidCallback signedOut;
  final List userData;

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isEmpty = true;
  SharedPreferences _sharedPreferences;
  List _childList;
  int _childId = 0;

  double _flexHeight(BuildContext context, double height) {
    return (MediaQuery.of(context).size.height * height / 774.8571428571429);
  }

  double _flexWidth(BuildContext context, double width) {
    return (MediaQuery.of(context).size.width * width / 411.42857142857144);
  }

  Future<List> _loadChildList() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      try {
        _childList = json.decode(_sharedPreferences.getString("dataChild")) ?? null;
      } catch (e) {
        print("Error: $e");
      }
    });
    return _childList;
  }

  void _setChildId(int id) {
    if (id != null) {
      setState(() {
        _childId = id;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChildList().then((list) {
      if (list != null) {
        setState(() {
          _isEmpty = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monitoring"),
        centerTitle: true,
      ),
      body: _body(),
      drawer: AppDrawer(
        signedOut: widget.signedOut,
        userData: widget.userData,
        setId: _setChildId,
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        Container(
          height: _flexHeight(context, MediaQuery.of(context).size.height),
          width: _flexWidth(context, MediaQuery.of(context).size.width),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("img/background.jpg"), fit: BoxFit.cover),
          ),
        ),
        _isEmpty ? empty() : profile(),
      ],
    );
  }

  Widget empty() {
    return Center(
      child: RaisedButton(
        elevation: 5,
        child: Text(
          "Pilih",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
        onPressed: () async {
          final int id = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChildList(
                userId: widget.userData[0]['id'],
                extract: Extracting(),
              ),
            ),
          );
          List list = await _loadChildList();
          if (list != null) {
            setState(() {
              _childList = list;
              if (id != null) {
                _childId = id;
              }
              _isEmpty = false;
            });
          }
        },
      ),
    );
  }

  Widget profile() {
    return Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: GetClipper(),
        ),
        Positioned(
          width: _flexWidth(context, MediaQuery.of(context).size.width),
          top: MediaQuery.of(context).size.height / 5,
          child: Column(
            children: <Widget>[
              Hero(
                tag: "profile$_childId",
                child: Container(
                  width: _flexWidth(context, 150),
                  height: _flexHeight(context, 150),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: CachedNetworkImage(
                      imageUrl: _childList[_childId]['foto'] == '?' ? "https://robohash.org/${_childList[_childId]['id']}?set=set3" : "https://ddspkmbareng.id/" + _childList[_childId]['foto'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SizedBox(height: _flexHeight(context, 90)),
              Container(
                height: _flexHeight(context, 40),
                color: Colors.white,
                child: Text(
                  _childList[_childId]['nama'],
                  // "adam",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width + 200, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
