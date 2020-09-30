import 'package:flutter/material.dart';
import '../controllers/exctract.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChildList extends StatefulWidget {
  const ChildList({Key key, this.userId, this.extract}) : super(key: key);

  final String userId;
  final Extract extract;

  _ChildListState createState() => _ChildListState();
}

class _ChildListState extends State<ChildList> {
  bool isLoading = true;
  List _childList;
  SharedPreferences _sharedPreferences;
  bool reload = true;

  double _flexHeight(BuildContext context, double height) {
    return (MediaQuery.of(context).size.height * height / 774.8571428571429);
  }

  double _flexWidth(BuildContext context, double width) {
    return (MediaQuery.of(context).size.width * width / 411.42857142857144);
  }

  void _saveChildList() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String dataJson = json.encode(_childList);
    setState(() {
      _sharedPreferences.setString("dataChild", dataJson);
      reload = false;
    });
  }

  Future<List> _loadChildList() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      try {
        _childList =
            json.decode(_sharedPreferences.getString("dataChild")) ?? null;
      } catch (e) {
        print("Error: $e");
      }
    });
    return _childList;
  }

  @override
  void initState() {
    super.initState();
    _loadChildList().then((list) {
      if (list != null) {
        setState(() {
          reload = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                reload = true;
              });
            },
          ),
        ],
        title: Text("Child List"),
        centerTitle: true,
      ),
      body: reload ? _loading() : _listBuilder(context),
    );
  }

  _loading() {
    return FutureBuilder(
      future: widget.extract.extractData(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _childList = snapshot.data;
          reload = false;
          _saveChildList();
          return _listBuilder(context);
        } else if (snapshot.hasError) {
          return Center(
            child: Icon(Icons.error),
          );
        }
        return _progress();
      },
    );
  }

  Widget _progress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _listBuilder(BuildContext context) {
    return ListView.builder(
      itemCount: _childList.length,
      itemBuilder: (context, index) {
        dynamic _child = _childList[index];
        return _card(
          id: _child['id'],
          nama: _child['nama'],
          bb: _child['stsBB'],
          tb: _child['stsTB'],
          warnaTB: _child['stsTBcolor'] == "d"
              ? Colors.red
              : _child['stsTBcolor'] == "w"
                  ? Colors.yellow
                  : _child['stsTBcolor'] == "s" ? Colors.green : Colors.black,
          warnaBB: _child['stsBBcolor'] == "d"
              ? Colors.red
              : _child['stsBBcolor'] == "w"
                  ? Colors.yellow
                  : _child['stsBBcolor'] == "s" ? Colors.green : Colors.black,
          foto: _child['foto'],
          index: index,
        );
      },
    );
  }

  Widget _card(
      {String id,
      String nama,
      String bb,
      String tb,
      Color warnaBB,
      Color warnaTB,
      String foto,
      int index}) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        child: Container(
          height: _flexHeight(context, 100),
          child: InkWell(
            child: Row(
              children: <Widget>[
                Hero(
                  tag: "profile$index",
                  child: Container(
                    height: _flexHeight(context, 100),
                    width: _flexWidth(context, 100),
                    child: CachedNetworkImage(
                      imageUrl: foto == '?'
                          ? "https://robohash.org/" + id + "?set=set3"
                          : "https://ddspkmbareng.id/" + foto,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Container(
                  width: 243,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        nama,
                        style: TextStyle(fontSize: 20),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            bb,
                            style: TextStyle(
                                fontSize: 17,
                                color: warnaBB,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            tb,
                            style: TextStyle(
                                fontSize: 17,
                                color: warnaTB,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context, index);
            },
            splashColor: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}
