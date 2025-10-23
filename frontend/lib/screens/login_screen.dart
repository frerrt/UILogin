import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/login_bloc.dart'; 
import 'package:frontend/auth/events/login_event.dart'; 
import 'package:frontend/auth/states/login_state.dart'; 
import 'package:frontend/screens/home_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'test@rociny.com'); // Pré-rempli pour la démo
  final _passwordController = TextEditingController(text: 'password'); // Pré-rempli pour la démo

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginSubmitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Utiliser MediaQuery pour un design responsif
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Container(
        // Fond dégradé
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A148C), Color(0xFF880E4F)], // Tons violets et bordeaux
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            // Afficher une erreur si l'état est LoginFailure
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      state.error,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
            // La navigation vers HomeScreen est gérée dans le Widget principal (main.dart)
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo ou icône de l'entreprise
                  if (!isKeyboardOpen)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Icon(
                        Icons.lock_person_rounded,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),

                  // Carte de connexion stylisée
                  _buildLoginCard(context),
                  
                  // Message d'information sur les identifiants
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Identifiants pré-remplis pour la démo.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    final state = context.watch<LoginBloc>().state;
    final isLoading = state is LoginLoading;

    return Container(
      padding: const EdgeInsets.all(30.0),
      // Style de carte avec des coins arrondis et une ombre douce
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 25,
            offset: const Offset(0, 10), // Déplacement vers le bas
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Bienvenue chez Rociny',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A148C),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          
          // Champ Email
          _buildTextField(
            controller: _emailController,
            hintText: 'Adresse email',
            icon: Icons.email_rounded,
          ),
          const SizedBox(height: 20),

          // Champ Mot de passe
          _buildTextField(
            controller: _passwordController,
            hintText: 'Mot de passe',
            icon: Icons.lock_rounded,
            isPassword: true,
          ),
          const SizedBox(height: 30),

          // Bouton de connexion
          ElevatedButton(
            onPressed: isLoading ? null : _onLoginButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A148C), // Couleur principale
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'SE CONNECTER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
  
  // Widget pour un champ de texte stylisé
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Supprimer la bordure par défaut
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF880E4F), width: 2), // Couleur d'accent
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      ),
    );
  }
}
