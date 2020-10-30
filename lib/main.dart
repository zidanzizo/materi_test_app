import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/auth.dart';
import 'screen/login_screen.dart';
import 'screen/dashboard_screen.dart';
import 'screen/history_screen.dart';
import 'screen/information_screen.dart';
import 'screen/profile_screen.dart';
import 'screen/splash_screen.dart';
import 'screen/main_screen.dart';
import 'screen/scanner_screen.dart';
import 'screen/about_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter asaba test',
            theme: ThemeData(
              primaryColor: Color(0xFF131E9E),
              accentColor: Color(0xFF131E9E),
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth
                ? MainScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : LoginScreen(),
                  ),
            // home: LoginScreen(),
            routes: {
              MainScreen.route_name: (context) => MainScreen(),
              DashboardScreen.route_name: (context) => DashboardScreen(),
              HistoryScreen.route_name: (context) => HistoryScreen(),
              InformationScreen.route_name: (context) => InformationScreen(),
              ProfileScreen.route_name: (context) => ProfileScreen(),
              ScannerScreen.route_name: (context) => ScannerScreen(),
            },
          );
        },
      ),
    );
  }
}
