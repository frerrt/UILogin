import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth/bloc/login_bloc.dart';
import 'auth/repository/auth_repository.dart';
import 'auth/events/login_event.dart'; 
import 'auth/states/login_state.dart'; 
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; 

void main() {
  final AuthRepository authRepository = AuthRepository();
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (context) => LoginBloc(authRepository: authRepository)
          ..add(AppStarted()),
        child: MaterialApp(
          title: 'Rociny Login Case',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const AppRouter(),
        ),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
          // Si succès (suite à connexion ou Auto-Login), on va à l'accueil
          return HomeScreen(token: state.token);
        }
        
        // Par défaut (Initial, Loading, Failure), on montre l'écran de connexion
        return const LoginScreen(); 
      },
    );
  }
}