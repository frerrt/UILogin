import 'package:bloc/bloc.dart';
import '../events/login_event.dart';
import '../states/login_state.dart';
import '../repository/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    // Enregistre les handlers
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginLoggedOut>(_onLoginLoggedOut); 
    
    // Enregistrement du handler pour l'Auto-Login
    on<AppStarted>(_onAppStarted); 
  }

  // Fonction asynchrone pour gérer l'événement LoginSubmitted
  void _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final token = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      // Utilise l'état LoginSuccess avec le token
      emit(LoginSuccess(token));
      
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
  
  // Fonction asynchrone pour gérer l'événement LoginLoggedOut
  void _onLoginLoggedOut(
    LoginLoggedOut event,
    Emitter<LoginState> emit,
  ) async { 
    // Supprime le token
    await authRepository.deleteToken(); 
    emit(LoginInitial());
  }

  // Gère l'événement de démarrage pour l'Auto-Login
  void _onAppStarted(
    AppStarted event,
    Emitter<LoginState> emit,
  ) async {
    // Lit le token stocké
    final token = await authRepository.readToken();
    
    if (token != null) {
      // Si un token est trouvé, l'utilisateur est connecté.
      emit(LoginSuccess(token));
    } else {
      // Sinon, affiche l'écran de connexion.
      emit(LoginInitial());
    }
  }
}
