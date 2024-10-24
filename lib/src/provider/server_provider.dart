import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:milike/src/utils/settings.dart';
import 'package:http/http.dart' as http;

class Server {
  final String host = Settings.apiDominio;
  final box = GetStorage();

  login(data) async {
    var url = Uri.http(host, "/api/v1/auth/login");
    return await http.post(url, body: jsonEncode(data), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      return http.Response(
        '{"success": false, "message": "Tiempo de espera excedido", "data": []}',
        408,
      );
    });
  }

  getPosts() async {
    var token = box.read('token');
    var url = Uri.http(host, "/api/v1/post/user");
    return await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      return http.Response(
        '{"success": false, "message": "Tiempo de espera excedido", "data": []}',
        408,
      );
    });
  }

  getAllPosts() async {
    var token = box.read('token');
    var url = Uri.http(host, "/api/v1/post");
    return await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      return http.Response(
        '{"success": false, "message": "Tiempo de espera excedido", "data": []}',
        408,
      );
    });
  }

  createPost(data) async {
    var token = box.read('token');
    var url = Uri.http(host, "/api/v1/post");
    return await http
        .post(url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode(data))
        .timeout(const Duration(seconds: 20), onTimeout: () {
      return http.Response(
        '{"success": false, "message": "Tiempo de espera excedido", "data": []}',
        408,
      );
    });
  }

  createReaccion(data) async {
    var token = box.read('token');
    var url = Uri.http(host, "/api/v1/post/reaccion");
    return await http
        .post(url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode(data))
        .timeout(const Duration(seconds: 20), onTimeout: () {
      return http.Response(
        '{"success": false, "message": "Tiempo de espera excedido", "data": []}',
        408,
      );
    });
  }
}
