import 'dart:math';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';

import '../di/app_component.dart';
import '../routes/route.dart';
import '../session/session_manager.dart';


class NavDraw extends StatefulWidget {
  @override
  _NavDrawState createState() => _NavDrawState();
}

int selectedIndex = 0;

class _NavDrawState extends State<NavDraw> with TickerProviderStateMixin {
  var session = locator<SessionManager>();

  @override
  late final AnimationController _controller = AnimationController(
    duration: const Duration(microseconds: 1000),
    vsync: this,
  )..reverse(from: 45);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool switchValue = session.darkTheme;
    return Drawer(
      width: .6.sw,
      child: ListView(
        children: <Widget>[
          Stack(
            children: [
              Container(
                color: Colors.black45,
                height: 200.0,
                child: DrawerHeader(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: EdgeInsets.zero,
                  child: SvgPicture.asset(
                    'assets/svg/newsly.svg',
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: RotationTransition(
                  
                  turns: _animation,
                  child: Transform.rotate(
                    angle: -0.5,
                    child: ThemeSwitcher(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          var brightness = ThemeModelInheritedNotifier.of(context)
                              .theme
                              .brightness;
                          ThemeSwitcher.of(context).changeTheme(
                              theme: brightness == Brightness.light
                                  ? NewslyThemeData.dark()
                                  : NewslyThemeData.light());
                          switchValue = !switchValue;
                          session.darkTheme = switchValue;
                        },
                        child: Icon(
                          switchValue ? Icons.nightlight_round : Icons.sunny,
                          color: switchValue ? Colors.white : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          _createDrawerItem(
              icon: Icons.home_outlined,
              text: 'Home',
              isSelected: selectedIndex == 0,
              onTap: () {
                if (selectedIndex != 0) {
                  Navigator.pushNamed(context, home);
                } else {
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
                if (selectedIndex != 1) {
                  Navigator.pushNamed(context, bookmarkPage);
                } else {
                  Navigator.pop(context);
                }
                setState(() {
                  selectedIndex = 1;
                });
              }),
        ],
      ),
    );
  }
}

Widget _createDrawerItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    required bool isSelected}) {
  return ListTile(
    tileColor:
        isSelected ? NewslyThemeData.primaryColor : Colors.transparent,
    // selected: true,
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
