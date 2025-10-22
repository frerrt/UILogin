import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Import nécessaire pour les appels réseau

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UILogin Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // C'est la nouvelle page d'accueil (LoginScreen)
      home: const LoginScreen(), 
    );
  }
}

// ----------------------------------------------------
// Widget d'État pour l'Interface Utilisateur de Connexion et la Logique API
// ----------------------------------------------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Contrôleurs pour récupérer les données des champs de texte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = 'Entrez vos identifiants et appuyez sur Login.';

  // Fonction de gestion de la connexion avec la méthode POST corrigée
  Future<void> _handleLogin() async {
    setState(() {
      _message = 'Connexion en cours...';
    });
    
    // 🌐 L'URL de votre serveur NestJS (port 3000 par défaut)
    // IMPORTANT : Si vous utilisez un émulateur Android, remplacez 'localhost' par '10.0.2.2'
    const String baseUrl = 'http://localhost:3000'; 
    final url = Uri.parse('$baseUrl/auth/login');
    
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // ⭐️ C'est la correction : Utilisation de http.post avec le body JSON
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Le code 201 (Created) est typique d'une connexion réussie avec un token
        final data = jsonDecode(response.body);
        setState(() {
          _message = 'SUCCÈS ! Token: ${data['access_token'].substring(0, 15)}...';
        });
        // Logique de navigation ici...
      } else {
        // Échec de la connexion (ex: 401 Unauthorized)
        setState(() {
          _message = 'ÉCHEC : Code ${response.statusCode}. Vérifiez vos identifiants.';
        });
      }
    } catch (e) {
      // Erreur de connexion au serveur (ex: NestJS n'est pas démarré)
      setState(() {
        _message = 'Erreur Réseau : Assurez-vous que NestJS tourne sur $baseUrl.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter NestJS Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Connexion',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleLogin, // Appelle la fonction POST
              child: const Text('Login'),
            ),
            const SizedBox(height: 30),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}