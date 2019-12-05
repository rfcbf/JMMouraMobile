import 'dart:async';
import 'package:cadastromoura/model/cadastro.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

const request = "https://renatocadastro.herokuapp.com/v1/cadastro";

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
    final headers = {'Content-Type': 'application/json'};
    String jsonBody = json.encode(cadastro.toJson());
    final encoding = Encoding.getByName('utf-8');

    return await http
        .post(
          Uri.encodeFull(request),
          headers: headers,
          body: jsonBody,
          encoding: encoding,
        )
        .then((response) {})
        .catchError((onError) {
      throw new Exception("Erro ao incluir");
    });
  }

  static Future delete(String id) async {
    String url = request + "/$id";

    return await http
        .delete(Uri.encodeFull(url), headers: {"Accept": "application/json"}).then((http.Response response) {});
  }

  static Future update(Cadastro cadastro) async {
    final headers = {'Content-Type': 'application/json'};
    String jsonBody = json.encode(cadastro.toJson());
    final encoding = Encoding.getByName('utf-8');

    return await http
        .put(
          Uri.encodeFull(request),
          headers: headers,
          body: jsonBody,
          encoding: encoding,
        )
        .then((response) {})
        .catchError((onError) {
      throw new Exception("Erro ao atualizar");
    });
  }
}
