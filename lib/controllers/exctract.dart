import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class Extract {
  Future<List> extractData(String id);
}

class Extracting implements Extract {
  Future<List> extractData(String id) async {
    http.Response response;
    try {
      String parseId = id.toString();
      response = await http.post(
        "https://ddspkmbareng.id/index.php/Flutter_Auth/childList",
        body: {"id": parseId},
      );
    } catch (e) {
      print("Error: $e");
    }
    return json.decode(response.body);
  }
}
