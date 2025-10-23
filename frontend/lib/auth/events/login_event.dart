import 'package:equatable/equatable.dart';

// Classe de base pour tous les événements de connexion
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// Événement déclenché lorsque l'utilisateur clique sur le bouton "Login"
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// Événements pour la saisie de texte (utiles pour la validation en direct)
class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged(this.email);
  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);
  @override
  List<Object> get props => [password];
}

// Événement déclenché lorsque l'utilisateur se déconnecte
class LoginLoggedOut extends LoginEvent {}

// ⭐️ ÉVÉNEMENT MANQUANT : Déclenché au démarrage de l'application pour vérifier la session ⭐️
class AppStarted extends LoginEvent {}