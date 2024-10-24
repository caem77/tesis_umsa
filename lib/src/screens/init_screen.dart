import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milike/src/screens/home_screen.dart';
import 'package:milike/src/screens/post_screen.dart';
import 'package:milike/src/screens/login_screen.dart';
import 'package:milike/src/utils/local_storage.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool isExpiredToken = LocalStorage().isExpired();
  final box = GetStorage();
  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkAuthStatus(), // función asíncrona que verifica el estado
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Indicador de carga
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else if (snapshot.data == false) {
          return const LoginScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }

  Future<bool> checkAuthStatus() async {
    bool isExpiredToken = await LocalStorage().isExpired(); // Si es asíncrono
    bool isAuth = box.read('is_auth') ?? false;
    return !isExpiredToken && isAuth;
  }
}
