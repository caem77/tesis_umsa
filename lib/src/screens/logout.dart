import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milike/src/screens/login_screen.dart';
import 'package:milike/src/utils/local_storage.dart';

class Logout extends StatefulWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  LocalStorage localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    // Esperar un tiempo breve antes de cerrar sesión y redirigir
    Future.delayed(Duration.zero, () async {
      await logout(); // Llamada asíncrona al logout
    });
  }

  Future<void> logout() async {
    localStorage.logout();
    Get.to(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
