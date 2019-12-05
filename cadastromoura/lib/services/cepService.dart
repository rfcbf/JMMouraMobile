import 'package:cadastromoura/model/cep.dart';
import 'package:http/http.dart' as http;

class CepService {
  static Future<Cep> fetchCep({String cep}) async {
    final response = await http.get('https://viacep.com.br/ws/$cep/json/');
    if (response.statusCode == 200) {
      return Cep.fromJson(response.body);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
