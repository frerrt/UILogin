import 'package:equatable/equatable.dart';

// Classe de base pour tous les événements
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// 1. Événement déclenché au démarrage de l'application (pour l'auto-login)
class AppStarted extends LoginEvent {}

// 2. Événement pour la soumission du formulaire de connexion
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// 3. Événement pour la déconnexion
class LoginLoggedOut extends LoginEvent {}