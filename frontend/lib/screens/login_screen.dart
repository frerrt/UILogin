import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/login_bloc.dart';
import '../auth/events/login_event.dart';
import '../auth/states/login_state.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Nous utilisons un BlocProvider ici pour fournir le Bloc à l'ensemble du Widget
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter NestJS Login (BLoC)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // Le BlocListener écoute les changements d'état pour la navigation/snackbars
         child: BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      // ⭐️ NOUVEAU : Navigation vers l'écran d'accueil
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(token: state.token),
        ),
      );
      // La Snackbar n'est plus nécessaire ici mais laissons-la pour une meilleure UX:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connexion réussie ! Redirection...')),
      );
    } else if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ÉCHEC : ${state.error}'), backgroundColor: Colors.red),
      );
    }
  },
  // Le BlocBuilder reconstruit l'interface utilisateur en fonction de l'état
  child: const LoginForm(),
),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email (afrid.azar@gmail.com)'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe (afrid)'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            // Afficher le spinner si l'état est Loading
            if (state is LoginLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: () {
                  // Envoie l'événement LoginSubmitted au Bloc
                  BlocProvider.of<LoginBloc>(context).add(
                    LoginSubmitted(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
                },
                child: const Text('Login'),
              ),
          ],
        );
      },
    );
  }
}