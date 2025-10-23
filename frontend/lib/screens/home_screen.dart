import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/repository/auth_repository.dart'; // NÉCESSAIRE pour le fetch des données
import '../auth/bloc/login_bloc.dart';
import '../auth/events/login_event.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variable d'état pour stocker le résultat de l'appel API sécurisé
  String _protectedData = 'Chargement des données sécurisées...'; 

  @override
  void initState() {
    super.initState();
    // ⭐️ DÉCLENCHE LA RÉCUPÉRATION DES DONNÉES AU DÉMARRAGE DE L'ÉCRAN ⭐️
    _fetchData(); 
  }

  // Fonction pour appeler la route protégée de NestJS
  void _fetchData() async {
    try {
      // Accès au AuthRepository via le contexte BLoC
      final authRepository = context.read<AuthRepository>(); 
      
      // Utilise le token pour faire l'appel sécurisé
      final data = await authRepository.fetchProtectedData(widget.token);
      
      setState(() {
        _protectedData = data; // Affiche les données sécurisées
      });
    } catch (e) {
      setState(() {
        _protectedData = 'Erreur lors de l\'accès sécurisé: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil Sécurisé'),
        automaticallyImplyLeading: false,
        actions: [
          // Bouton de déconnexion simplifié
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // ⭐️ C'EST LA BONNE MÉTHODE : ENVOYER L'EVENT AU BLoC ⭐️
              // L'AppRouter dans main.dart gérera le retour à LoginScreen.
              context.read<LoginBloc>().add(LoginLoggedOut()); 
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start, // Alignement pour le texte long
            children: [
              const Text(
                'Connexion Réussie !',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 20),
              
              // ⭐️ AFFICHAGE DU RÉSULTAT DE L'APPEL SÉCURISÉ ⭐️
              const Text(
                'Données de la Ressource Protégée :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              SelectableText(
                _protectedData,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),

              // Affiche le début du token
              const Text(
                'Token JWT (pour référence) :',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              SelectableText(
                '${widget.token.substring(0, 30)}...',
                style: const TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}