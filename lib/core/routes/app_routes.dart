import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/core/routes/route.dart';
import 'package:newsly/home/presentation/ui/home_page.dart';
import '../../home/presentation/bloc/home_bloc.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        {
          return MaterialPageRoute(
            builder: (_) {
              return MultiBlocProvider(providers: [
                BlocProvider<HomeBloc>(
                  create: (BuildContext context) => HomeBloc(),
                ),
              ], child: const HomePage());
            },
          );
        }
      default:
        {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text("No route defined for ${routeSettings.name}"),
              ),
            ),
          );
        }
    }
  }
}
