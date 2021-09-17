import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/helper/helper.dart';
import 'package:test_app/notifier/auth_notifier.dart';
import 'package:test_app/notifier/users_notifier.dart';
import 'package:test_app/page/home_page.dart';
import 'package:test_app/page/login_page/login_page.dart';
import 'package:test_app/page/user_page/create_user_page.dart';

class MainApp extends StatefulWidget {

  final String? initialRoute;

  const MainApp({
    Key? key,
    this.initialRoute
  }) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState(
    initialRoute: initialRoute
  );
}

class _MainAppState extends State<MainApp> {

  String? initialRoute;

  _MainAppState({this.initialRoute});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthNotifier()),
        ChangeNotifierProvider(create: (_) => UsersNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          LoginPage.route_name : (_) => LoginPage(),
          HomePage.route_name: (_) => HomePage(),
          CreateUserPage.route_name: (_) => CreateUserPage(
            mode: Helper.modeCreate,
          ),
        },
      ),
    );
  }
}
