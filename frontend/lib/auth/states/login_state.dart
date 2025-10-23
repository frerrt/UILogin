import 'package:equatable/equatable.dart';

// Classe de base pour tous les états de connexion
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

// 1. État Initial : L'application vient de démarrer
class LoginInitial extends LoginState {}

// 2. État de Chargement : La requête API est en cours
class LoginLoading extends LoginState {}

// 3. État de Succès : La connexion a réussi (le token est reçu)
class LoginSuccess extends LoginState {
  final String token;

  const LoginSuccess(this.token);

  @override
  List<Object> get props => [token];
}

// 4. État d'Échec : La connexion a échoué (identifiants invalides ou erreur)
class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}