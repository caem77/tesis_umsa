import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:milike/src/screens/login_screen.dart';
import 'package:milike/src/utils/alert.dart';

class LocalStorage {
  final box = GetStorage();

  guardarDatos(datos) {
    print('Guardando datos $datos[token]');
    print(datos['token']);
    box.write('token', datos['token']);
    box.write('id_usuario', datos['id']);
    box.write('nombre', datos['nombre']);
    box.write('rol', datos['rol']);
    box.write('direccion', datos['direccion']);
    box.write('is_auth', true);
  }

  bool isExpired() {
    var token = box.read('token');
    print("token: $token");
    if (token != null) {
      print("JwtDecoder.isExpired(token) ${JwtDecoder.isExpired(token)}");
      return JwtDecoder.isExpired(token);
    } else {
      return true;
    }
  }

  void logout() {
    box.remove('token');
    box.remove('id_usuario');
    box.remove('nombre');
    box.remove('rol');
    box.remove('rodireccionl');
    box.write('is_auth', false);
    Get.to(() => const LoginScreen());
    Alert.success("Se sesion terminada.");
  }

  void logoutJwt() {
    box.remove('token');
    box.remove('id_usuario');
    box.remove('nombre');
    box.remove('rol');
    box.remove('rodireccionl');
    box.write('is_auth', false);
    Get.to(() => const LoginScreen());
    Alert.error("Se sesion expirada, vuelva a iniciar sesión");
  }
}
