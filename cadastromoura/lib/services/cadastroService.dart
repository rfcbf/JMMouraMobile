import 'dart:async';
import 'package:cadastromoura/model/cadastro.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// const request = "https://todo-renato.herokuapp.com/api";
const request = "https://jsonmock.com/api/get/tuGFQ4iBxrfAvlyZagm5N6IvteyNVX13";

class CadastroService {
  static Future<List<Cadastro>> getCadsatro() async {
    final response = await http.get(request);
    return compute(parseCadastro, response.body);
  }

  static List<Cadastro> parseCadastro(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Cadastro>((json) => Cadastro.fromJson(json)).toList();
  }

  static Future post(Cadastro cadastro) async {
    return await http.post(Uri.encodeFull(request),
        body: cadastro.toJson(), headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
    });
  }

  static Future delete(String id) async {
    String url = request + "/$id";

    return await http
        .delete(Uri.encodeFull(url), headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
    });
  }

  static Future update(String id) async {
    String url = request + "/$id";

    return await http.put(Uri.encodeFull(url), headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
    });
  }
}
