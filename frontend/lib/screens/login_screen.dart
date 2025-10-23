import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/login_bloc.dart';
import 'package:frontend/auth/events/login_event.dart';
import 'package:frontend/auth/states/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Identifiants de démo génériques
  final _emailController = TextEditingController(text: 'test@rociny.com');
  final _passwordController = TextEditingController(text: 'password');

  // État local pour gérer la visibilité du mot de passe
  bool _isPasswordVisible = false;

  // Définition de la couleur principale pour le thème (VERT TRÈS FONCÉ)
  final Color _primaryColor = Colors.green.shade900;
  // Couleur d'accentuation calquée sur la couleur principale (vert très foncé)
  final Color _accentColor = Colors.green.shade900; 

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

  // WIDGET : Simule le logo Google avec un dégradé de quatre couleurs sur l'icône 'G'
  Widget _buildGoogleIconFallback() {
    // Les quatre couleurs officielles de Google : Rouge, Jaune, Vert, Bleu
    final List<Color> googleColors = [
      const Color(0xFFEA4335), // Rouge (Top)
      const Color(0xFFFBBC05), // Jaune
      const Color(0xFF34A853), // Vert
      const Color(0xFF4285F4), // Bleu (Bottom)
    ];

    // Utiliser ShaderMask pour appliquer un dégradé linéaire à l'icône 'G'
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: googleColors,
          // Arrêts pour s'assurer que les couleurs couvrent des sections égales
          stops: const [0.0, 0.25, 0.5, 0.75], 
          // Dégradé VERTICAL (du haut vers le bas) pour mieux afficher les couleurs
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      child: const Icon(
        Icons.g_mobiledata_rounded,
        size: 28,
        // La couleur de l'icône doit être blanche pour que le ShaderMask fonctionne correctement
        color: Colors.white, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Utiliser MediaQuery pour un design responsif
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      // Fond uni blanc
      backgroundColor: Colors.white,
      body: Center(
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
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo ou icône de l'entreprise
                if (!isKeyboardOpen)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Icon(
                      Icons.lock_person_rounded,
                      size: 80,
                      // Icône en couleur accent
                      color: _accentColor,
                    ),
                  ),

                // Carte de connexion stylisée
                _buildLoginCard(context),
                
                // Message d'information sur les identifiants
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Identifiants de démo pré-remplis (test@rociny.com / password).",
                    style: TextStyle(
                      // Texte en gris foncé sur fond clair
                      color: Colors.grey.shade600,
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
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 5), // Déplacement vers le bas
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Connexion',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // Titre en noir
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Message descriptif
          const SizedBox(height: 8),
          const Text(
            'Entrez votre email et mot de passe pour vous connecter.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 25),
          
          // Champ Email
          _buildTextField(
            controller: _emailController,
            hintText: 'E-mail',
            icon: Icons.email_rounded,
          ),
          const SizedBox(height: 20),

          // Champ Mot de passe (avec toggle de visibilité)
          _buildTextField(
            controller: _passwordController,
            hintText: 'Mot de passe',
            icon: Icons.lock_rounded,
            isPassword: !_isPasswordVisible, // Utilise l'état local ici
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible; // Met à jour l'état
                });
              },
            ),
          ),
          
          // Lien Mot de passe oublié?
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Implémenter la navigation vers l'écran de réinitialisation
                print('Mot de passe oublié pressé!');
              },
              child: Text(
                'Mot de passe oublié?',
                style: TextStyle(color: _primaryColor, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          
          const SizedBox(height: 15), // Espace ajusté avant le bouton principal

          // Bouton de connexion
          ElevatedButton(
            onPressed: isLoading ? null : _onLoginButtonPressed,
            style: ElevatedButton.styleFrom(
              // Couleur de fond en vert très foncé
              backgroundColor: _primaryColor, 
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
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          
          const SizedBox(height: 30),
          
          // Séparateur "ou"
          _buildSeparator(),

          const SizedBox(height: 30),

          // Boutons de connexion sociale
          _buildSocialButtons(),
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
    Widget? suffixIcon, // Ajout pour l'icône de l'œil
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        suffixIcon: suffixIcon, // Ajout de l'icône suffixe
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
          // La bordure de focus utilise la couleur principale
          borderSide: BorderSide(color: _primaryColor, width: 2), 
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      ),
    );
  }
  
  // Nouveau Widget: Séparateur avec "ou"
  Widget _buildSeparator() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'ou',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  // Nouveau Widget: Boutons de connexion sociale
  Widget _buildSocialButtons() {
    // Utilisation de la nouvelle fonction pour créer l'icône
    final Widget customGoogleIcon = _buildGoogleIconFallback();

    return Row(
      children: [
        // Bouton Google
        Expanded(
          child: _buildSocialButton(
            logo: Image.network(
              // URL du logo Google (Le logo classique)
              'https://upload.wikimedia.org/wikipedia/commons/4/4a/Logo_Google_g_standard.png',
              height: 24,
              width: 24,
              // Fallback avec l'icône multicolore personnalisée si l'image externe échoue.
              errorBuilder: (context, error, stackTrace) => customGoogleIcon,
            ),
            // Mise à jour de l'action pour simuler la redirection
            onPressed: () {
              // TODO: Implémenter la logique d'authentification Google (ex: Firebase Auth)
              print('Tentative de connexion avec Google... (Redirection simulée)');
            }
          ),
        ),
        const SizedBox(width: 20),
        // Bouton Apple
        Expanded(
          child: _buildSocialButton(
            logo: const Icon(Icons.apple, size: 28, color: Colors.black),
            // Mise à jour de l'action pour simuler la redirection
            onPressed: () {
              // TODO: Implémenter la logique d'authentification Apple (ex: Firebase Auth)
              print('Tentative de connexion avec Apple... (Redirection simulée)');
            }
          ),
        ),
      ],
    );
  }

  // Sous-widget pour le style des boutons sociaux
  Widget _buildSocialButton({required Widget logo, required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        backgroundColor: Colors.white,
        elevation: 2,
        // Enlève l'effet de survol ou de splash par défaut s'il y en a
      ),
      child: logo,
    );
  }
}
