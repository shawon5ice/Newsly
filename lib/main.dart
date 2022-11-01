import 'dart:async';
import 'dart:convert';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:json_theme/json_theme.dart';
import 'package:newsly/core/service/bookmark/bookmark.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';

import 'core/di/app_component.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route.dart';
import 'core/session/session_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<Bookmark>('bookmarks');
  // Pass all uncaught errors from the framework to Crashlytics.
  // final themeStr = await rootBundle.loadString('assets/theme/app_theme.json');
  // final themeJson = jsonDecode(themeStr);
  // final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  if(kDebugMode){
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  await AppComponent().init();
  locator.isReady<SessionManager>().then((value) {
    var session = locator<SessionManager>();
    runApp(NewslyApp(session.isLoggedIn!));
  });
}


class NewslyApp extends StatelessWidget {
  final bool isLoggedIn;
  // final ThemeData theme;
  NewslyApp(this.isLoggedIn, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var session = locator<SessionManager>();
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context , child){
        return ThemeProvider(
            initTheme: session.darkTheme?NewslyThemeData.dark():NewslyThemeData.light(),
            builder: (_,theme){
              return MaterialApp(
                title: 'Newsly',
                theme: theme,
                onGenerateRoute: AppRoutes.generateRoute,
                initialRoute: home,
                // initialRoute: accountInfo,
                debugShowCheckedModeBanner: false,
              );
            }
        );
      },
    );
  }
}
