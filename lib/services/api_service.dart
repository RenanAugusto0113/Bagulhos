import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/bagulho_model.dart';

class ApiService {
/* Se não encontrar .env, então usa a URL de fallback da qual é a
mesma usada no desenvolvimento e portanto não é recomendada para uso */
  final String _url = dotenv.get(
    "API_URL",
    fallback: "https://6a01fab70d92f63dd2532587.mockapi.io/bag/v1/bagulhos",
  );

  // Buscar itens (GET)
  Future<List<Bagulho>> getBagulhos() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Bagulho.fromJson(item)).toList();
    } else {
      throw Exception("Erro ao buscar bagulhos: ${response.statusCode}");
    }
  }

  // Inserir item (POST)
  Future<void> addBagulho(Bagulho novo) async {

    final response = await http.post(
      Uri.parse(_url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(novo.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao inserir bagulho.");
    }
  }

  // Atualizar item (PUT)
  Future<void> updateBagulho(Bagulho item) async {
    final response = await http.put(
      Uri.parse("$_url/${item.id}"), // Precisamos do ID na URL
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar bagulho.");
    }
  }

  // Deletar item (DELETE)
  Future<void> deleteBagulho(String id) async {
    final response = await http.delete(Uri.parse("$_url/$id"));

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar bagulho.");
    }
  }
}