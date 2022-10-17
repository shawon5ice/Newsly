import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes/route.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xffd0d1dc),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60,),
            buildHeader(context),
            buildMenu(context),
          ],
        ),
      ),
    );
  }


  Widget buildHeader(BuildContext context){
    return Container();
  }

  Widget buildMenu(BuildContext context){
    return Container(
      padding: EdgeInsets.all(24),
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home'),
            onTap: (){
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, home);
            },
          ),
          ListTile(
            leading: Icon(Icons.nightlight_round),
            title: Text('Dark Mode'),
            trailing: CupertinoSwitch(
              value: false,
              onChanged: (value){

              },
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, bookmarkPage);
            },
            leading: Icon(Icons.bookmark),
            title: Text('Bookmarks'),
          ),
        ],
      ),
    );
  }
}
