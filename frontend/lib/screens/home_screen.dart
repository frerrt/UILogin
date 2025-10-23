import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // NÉCESSAIRE
import '../auth/bloc/login_bloc.dart'; // NÉCESSAIRE
import '../auth/events/login_event.dart'; // NÉCESSAIRE
import 'login_screen.dart'; // NÉCESSAIRE pour la navigation

class HomeScreen extends StatelessWidget {
  final String token; 
  
  const HomeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil Sécurisé'),
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Connexion Réussie !',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text('Vous êtes sur l\'écran principal.'),
              const SizedBox(height: 20),
              // Affiche le début du token
              Text(
                'Token JWT (début) : ${token.substring(0, 30)}...',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // ⭐️ LOGIQUE DE DÉCONNEXION CORRIGÉE ⭐️
              ElevatedButton(
                onPressed: () {
                  // 1. Accède au Bloc et à l'AuthRepository
                  final loginBloc = BlocProvider.of<LoginBloc>(context);
                  final authRepository = loginBloc.authRepository;

                  // 2. Envoie l'événement de déconnexion au Bloc
                  loginBloc.add(LoginLoggedOut());
                  
                  // 3. Navigue vers le LoginScreen, recréant le BlocProvider
                  // Cela garantit que le LoginScreen a bien accès à un LoginBloc actif.
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => LoginBloc(authRepository: authRepository),
                        child: const LoginScreen(),
                      ),
                    ),
                    (Route<dynamic> route) => false, // Supprime tout l'historique
                  );
                },
                child: const Text('Déconnexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}