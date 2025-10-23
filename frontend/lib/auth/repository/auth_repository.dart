// frontend/lib/auth/repository/auth_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
// flutter_secure_storage n'est plus importé

class AuthRepository {
  static const String _baseUrl = 'http://localhost:3000';
  
  // ⭐️ CONTOURNEMENT : Stockage du token en mémoire (NON SÉCURISÉ) ⭐️
  static String? _inMemoryToken; 

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    
    final body = jsonEncode(<String, String>{
      'email': email,
      'password': password,
    });
    
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        
        _inMemoryToken = token; // Enregistrement
        
        return token;
      } 
      else if (response.statusCode == 401) {
        _inMemoryToken = null;
        throw Exception('Identifiants invalides.');
      } else {
        throw Exception('Échec de la connexion: Code ${response.statusCode}');
      }
    } catch (e) {
      _inMemoryToken = null;
      throw Exception('Erreur réseau. Le backend NestJS est-il démarré ? Détails : $e');
    }
  }

  // LECTURE DU TOKEN EN MÉMOIRE
  Future<String?> readToken() async {
    return _inMemoryToken;
  }

  // SUPPRESSION DU TOKEN EN MÉMOIRE
  Future<void> deleteToken() async {
    _inMemoryToken = null;
  }
}