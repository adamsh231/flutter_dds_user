import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class BaseAuth {
  Future<List> logIn({String email, String password});
}

class Auth implements BaseAuth {
  Future<List> logIn({String email, String password}) async {
    final response = await http.post(
      "https://ddspkmbareng.id/index.php/Flutter_Auth/login",
      body: {"email": email, "password": password},
    );
    return json.decode(response.body);
  }
}
