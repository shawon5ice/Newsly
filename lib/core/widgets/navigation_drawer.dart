import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../di/app_component.dart';
import '../routes/route.dart';
import '../session/session_manager.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);
  var session = locator<SessionManager>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    bool switchValue = session.darkTheme;
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
            title: Text(switchValue?'Dark Mode':'Light Mode'),
            trailing: ThemeSwitcher(
              builder: (context)=> Switch.adaptive(
                value: switchValue,
                onChanged: (value){
                  var brightness =
                      ThemeModelInheritedNotifier.of(context)
                          .theme
                          .brightness;
                  ThemeSwitcher.of(context).changeTheme(
                      theme: brightness == Brightness.light?
                      ThemeData.dark():ThemeData.light());
                  switchValue = !switchValue;
                  session.darkTheme = switchValue;
                },
              )
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
