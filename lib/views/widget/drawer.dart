import 'package:flutter/material.dart';
import 'package:stunting/views/child.dart';
import '../../controllers/exctract.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({this.signedOut, this.userData, this.setId});

  final VoidCallback signedOut;
  final List userData;
  final ValueSetter<int> setId;

  String _userData(String attr) {
    return userData[0][attr];
  }

  double _flexHeight(BuildContext context, double height) {
    return (MediaQuery.of(context).size.height * height / 774.8571428571429);
  }

  double _flexWidth(BuildContext context, double width) {
    return (MediaQuery.of(context).size.width * width / 411.42857142857144);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
            icon: Icons.child_care,
            text: 'Monitoring',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.supervised_user_circle,
            text: 'Child List',
            onTap: () async {
              Navigator.pop(context);
              final int id = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChildList(
                    userId: _userData('id'),
                    extract: Extracting(),
                  ),
                ),
              );
              setId(id);
            },
          ),
          _createDrawerItem(
            icon: Icons.list,
            text: 'Record List',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.collections_bookmark,
            text: 'Steps',
          ),
          _createDrawerItem(
            icon: Icons.face,
            text: 'Authors',
          ),
          _createDrawerItem(
            icon: Icons.account_box,
            text: 'Flutter Documentation',
          ),
          _createDrawerItem(
            icon: Icons.stars,
            text: 'Useful Links',
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Log Out',
            onTap: () {
              Navigator.pop(context);
              logOut(context);
            },
          ),
          ListTile(
            title: Text('0.0.4'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are u sure?"),
          content: Text("Want to exit"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("LogOut"),
              textColor: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
                signedOut();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _createHeader(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('img/drawer_header_background.png'),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                height: _flexHeight(context, 100),
                width: _flexWidth(context, 100),
                color: Colors.white,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://robohash.org/" + _userData("id") + "?set=set4",
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
            Text(
              "Ny. " + _userData("nama"),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
