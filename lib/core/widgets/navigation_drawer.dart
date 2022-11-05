import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';

import '../di/app_component.dart';
import '../routes/route.dart';
import '../session/session_manager.dart';

// class NavigationDrawer extends StatefulWidget {
//   NavigationDrawer({Key? key}) : super(key: key);
//
//   @override
//   State<NavigationDrawer> createState() => _NavigationDrawerState();
// }
//
// class _NavigationDrawerState extends State<NavigationDrawer> {
//
//   var session = locator<SessionManager>();
//
//   int selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 60,),
//             buildHeader(context),
//             buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildHeader(BuildContext context){
//     return Container();
//   }
//
//   Widget buildMenu(BuildContext context){
//     bool switchValue = session.darkTheme;
//     return Container(
//       padding: EdgeInsets.all(24),
//       child: Wrap(
//         children: [
//           ListTile(
//             selectedColor: NewslyThemeData.primaryColor,
//             selected: selectedIndex == 0,
//             leading: Icon(Icons.home_outlined),
//             title: Text('Home'),
//             onTap: (){
//               setState(() {
//                 selectedIndex = 0;
//               });
//               Navigator.pushReplacementNamed(context, home);
//             },
//           ),
//
//           ListTile(
//             selectedColor: NewslyThemeData.primaryColor,
//             selected: selectedIndex == 2,
//             onTap: (){
//               setState(() {
//                 selectedIndex = 2;
//               });
//               Navigator.pop(context);
//               Navigator.pushReplacementNamed(context, bookmarkPage);
//             },
//             leading: Icon(Icons.bookmark),
//             title: Text('Bookmarks'),
//           ),
//         ],
//       ),
//     );
//   }
// }



class NavDraw extends StatefulWidget {
  @override
  _NavDrawState createState() => _NavDrawState();
}

int selectedIndex = 0;

class _NavDrawState extends State<NavDraw> {
  var session = locator<SessionManager>();

  @override
  Widget build(BuildContext context) {
    bool switchValue = session.darkTheme;
    return Drawer(
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 100.0,
            child: DrawerHeader(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.none,
                        image: NetworkImage(
                            'https://picsum.photos/250?image=9'))), child: null,),
          ),
          _createDrawerItem(
              icon: Icons.home_outlined,
              text: 'Home',
              isSelected: selectedIndex == 0,
              onTap: () {
                if(selectedIndex != 0){
                  Navigator.pushNamed(context, home);
                }else{
                  Navigator.pop(context);
                }
                setState(() {
                  selectedIndex = 0;
                });
              }),
          _createDrawerItem(
              icon: Icons.bookmark_outline,
              text: 'Bookmarks',
              isSelected: selectedIndex == 1,
              onTap: () {
                if(selectedIndex != 1){
                  Navigator.pushNamed(context, bookmarkPage);
                }else{
                  Navigator.pop(context);
                }
                setState(() {
                  selectedIndex = 1;
                });
              }),
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
                        NewslyThemeData.dark():NewslyThemeData.light());
                    switchValue = !switchValue;
                    session.darkTheme = switchValue;
                  },
                )
            ),
          ),

        ],
      ),
    );
  }
}

Widget _createDrawerItem(
    {required IconData icon, required String text, required GestureTapCallback onTap, required bool isSelected}) {
  return ListTile(
      selectedTileColor: isSelected ? NewslyThemeData.primaryColor : Colors.transparent,
      selected: true,
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
