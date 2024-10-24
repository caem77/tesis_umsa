import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milike/src/main_app.dart';
import 'package:milike/src/services/connectivity_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConnectivityService().initialize();
  await GetStorage.init();
  runApp(const MainApp());
}
