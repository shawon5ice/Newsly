import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsly/core/theme/newsly_theme_data.dart';

import 'core/di/app_component.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route.dart';
import 'core/session/session_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Pass all uncaught errors from the framework to Crashlytics.
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
  const NewslyApp(this.isLoggedIn, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context , child){
        return MaterialApp(
          title: 'Newsly',
          theme: NewslyThemeData.light(),
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: home,
          // initialRoute: accountInfo,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
