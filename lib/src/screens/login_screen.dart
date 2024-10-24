import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milike/src/provider/server_provider.dart';
import 'package:milike/src/screens/home_screen.dart';
import 'package:milike/src/screens/post_screen.dart';
import 'package:milike/src/services/connectivity_service.dart';
import 'package:milike/src/utils/alert.dart';
import 'package:milike/src/utils/local_storage.dart';
import 'package:milike/src/utils/settings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool passToogle = true;
  final formField = GlobalKey<FormState>();
  final _server = Server();
  final _storage = LocalStorage();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final Size size = media.size;
    return Scaffold(body: body(size));
  }

  Widget body(size) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.height,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: const AssetImage('assets/images/logo.png'),
                      alignment: Alignment.center,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.9),
                        BlendMode.dstATop,
                      ))),
            ),
            SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 300),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5))
                      ]),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Form(
                          key: formField,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _email,
                                autocorrect: false,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    hintText: 'Usuario',
                                    labelText: 'Usuario',
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded)),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Ingrese el usuario";
                                  } else if (_email.text.length < 3) {
                                    return "el usuario no puede tener menos de 3 caracteres";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _password,
                                autocorrect: false,
                                obscureText: passToogle,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: '********',
                                    labelText: 'Contraseña',
                                    prefixIcon:
                                        const Icon(Icons.lock_outline_rounded),
                                    suffix: InkWell(
                                      onTap: () {
                                        setState(() {
                                          passToogle = !passToogle;
                                        });
                                      },
                                      child: Icon(passToogle
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Ingrese la contraseña";
                                  } else if (_password.text.length < 4) {
                                    return "La contraseña no puede tener menos de 6 caracteres";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  disabledColor: Colors.grey,
                                  color: Settings.primary,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70, vertical: 15),
                                    child: const Text(
                                      'Ingresar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (formField.currentState!.validate()) {
                                      await _submit();
                                    }
                                  })
                            ],
                          )),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Versión ${Settings.version}',
                    style: TextStyle(color: Colors.black45),
                  ),
                )
              ],
            )),
          ],
        ));
  }

  _submit() async {
    bool connectivity = ConnectivityService().isConnected;
    if (connectivity == true) {
      var data = {'login': _email.text, 'password': _password.text};
      var result = await _server.login(data);
      var response = jsonDecode(result.body);
      if (response['success'] == true) {
        print('LOGIN CORRECTO');
        _storage.guardarDatos(response['data']);
        Get.to(() => const HomeScreen());
      } else if (response['message'] == 'Tiempo de espera excedido') {
        Alert.error(
            "El tiempo de espera a excedido. Verifique su conexion a internet.");
      } else {
        Alert.error(response['message'].toString());
      }
    } else {
      Alert.error("No hay conexión a internet");
    }
  }

  Container cajapurpura(Size size) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(11, 11, 145, 1),
          Color.fromRGBO(90, 70, 178, 1),
        ])),
        width: double.infinity,
        height: size.height * 0.4,
        child: Container());
  }
}
