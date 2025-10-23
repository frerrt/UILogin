Rociny Login Case — Afrid Azar

Ce projet met en œuvre un système d'authentification complet basé sur les bonnes pratiques du développement Full-Stack : Flutter (Frontend) pour l'interface utilisateur avec l'architecture BLoC, et NestJS (Backend) pour l'API et la gestion du JWT.

📁 Structure du Projet

rociny-login-case/
│
├── backend/ ← API NestJS (authentification, JWT)
│ ├── src/
│ │ ├── auth/ 
│ │ └── main.ts
│ ├── package.json
│ └── tsconfig.json
│
└── frontend/ ← App Flutter (UI, logique login)
    ├── lib/
    │   ├── blocs/         ← Gestion d'état (BLoC)
    │   ├── data_providers/ ← Couche API/Données (http calls)
    │   ├── screens/       ← Interface utilisateur (UI)
    │   └── main.dart
    ├── pubspec.yaml
    └── ...

⚙️ Démarrage du Projet

1. Backend (NestJS)

Détail	Valeur
URL de base	http://localhost:3000
Route de connexion	POST /auth/login
Identifiants valides	afrid.azar@gmail.com / afrid

    Naviguez vers le répertoire backend : cd backend

    Installez les dépendances : npm install

    Lancez le serveur en mode développement : npm run start:dev

2. Frontend (Flutter)

    Naviguez vers le répertoire frontend : cd ../frontend

    Installez les dépendances (http, flutter_bloc, etc.) : flutter pub get

    Lancez l'application : flutter run

🧠 Partie Backend — NestJS

🎯 Objectif

Mettre en place un système d’authentification simple basé sur JWT, avec une base de données simulée en mémoire (RAM).

🔐 Architecture d'Authentification (src/auth/)

Fichier	Rôle	Logique Clé
auth.service.ts	Logique métier	Simule les utilisateurs en mémoire. Valide les identifiants et utilise JwtService pour générer le token à partir du payload { email, sub: id }.
auth.controller.ts	Point d'entrée API	Définit la route POST /auth/login. Appelle le service et retourne le access_token ou une erreur 401 Unauthorized.
main.ts	Point d'entrée serveur	Initialise le serveur et le lance sur http://localhost:3000.

🎨 Partie Frontend — Flutter (Architecture BLoC)

Le frontend utilise l'architecture BLoC pour séparer la logique d'état de l'interface utilisateur, garantissant une application modulaire et testable.

🧱 Couches Principales

Composant	Rôle	Détail
LoginScreen	Présentation (UI)	Écoute le LoginBloc pour mettre à jour l'UI (afficher un spinner, un message de réussite, ou une erreur) et envoie des Events au Bloc.
AuthRepository	Couche de Données	Exécute l'appel http.post vers l'API NestJS (/auth/login). Gère la sérialisation/désérialisation JSON et le traitement initial des erreurs HTTP.
LoginBloc	Logique Métier (BLoC)	Reçoit les Events de l'UI (ex: LoginSubmitted), utilise l'AuthRepository pour communiquer avec NestJS, et émet des States (états) pour informer l'UI du résultat.

🔄 Cycle de Vie BLoC pour la Connexion

L'état de la connexion est géré par la transition des composants BLoC :

    UI ➡️ BLoC (Event) : L'utilisateur clique sur "Login" → L'UI envoie l'Event LoginSubmitted.

    BLoC (State Transition) : Le Bloc émet l'State LoginLoading (l'UI affiche un spinner).

    BLoC ➡️ Repository : Le Bloc appelle la fonction login() du AuthRepository.

    Repository ➡️ NestJS : Le Repository exécute la requête POST /auth/login.

    NestJS ➡️ BLoC (Token) : NestJS renvoie le token JWT.

    BLoC (Final State) :

        Si succès → Émet l'State LoginSuccess(token).

        Si échec → Émet l'State LoginFailure(message).

    BLoC ➡️ UI : L'UI réagit au nouvel état pour naviguer ou afficher l'erreur.