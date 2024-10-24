import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milike/src/screens/home_screen.dart';
import 'package:milike/src/screens/post_screen.dart';
import 'package:milike/src/screens/login_screen.dart';

import 'screens/init_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: false,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white),
      initialRoute: '/',
      routes: {
        '/': (context) => const InitScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/post': (context) => const PostScreen(),
      },
    );
  }
}
