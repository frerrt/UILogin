Rociny Login Case — Afrid Azar

Ce projet met en œuvre un système d'authentification complet basé sur les bonnes pratiques du développement Full-Stack : Flutter (Frontend) pour l'interface utilisateur avec l'architecture BLoC, et NestJS (Backend) pour l'API et la gestion du JWT.

📁 Structure du Projet

La structure a été affinée pour respecter l'architecture BLoC et intégrer les modules NestJS nécessaires à la sécurité.

rociny-login-case/
│
├── backend/ ← API NestJS (authentification, JWT, ressources sécurisées)
│ ├── src/
│ │ ├── auth/           ← Modules d'Auth, Controller, Service, Stratégie JWT
│ │ ├── auth/strategy/  ← Contient jwt.strategy.ts
│ │ ├── users/          ← Contient la ressource protégée (/users/profile)
│ │ └── main.ts
│ └── ...
│
└── frontend/ ← App Flutter (UI, logique login)
    ├── lib/
    │   ├── auth/         ← Contient Bloc, Events, States et Repository
    │   ├── screens/       ← LoginScreen, HomeScreen
    │   └── main.dart
    └── ...


⚙️ Démarrage du Projet

1. Backend (NestJS)

Détail :
URL de base :

http://localhost:3000

Route de connexion :

POST /auth/login

Ressource Protégée :

GET /users/profile

Identifiants valides

Email : afrid.azar@gmail.com / MDP : afrid   // backend/src/auth/auth.service.ts

Naviguez vers le répertoire backend : cd backend

Installez les dépendances : npm install

Lancez le serveur en mode développement : npm run start:dev

2. Frontend (Flutter)

Naviguez vers le répertoire frontend : cd ../frontend

Installez les dépendances : flutter pub get

Lancez l'application : flutter run

🧠 Partie Backend — NestJS

🎯 Objectif

Mettre en place un système d’authentification JWT fonctionnel, incluant la génération et la validation du token, ainsi que la protection d'une ressource.

🔐 Architecture d'Authentification

Fichier/Composant

Rôle

Logique Clé

auth.module.ts

Configuration

Importe PassportModule et ajoute JwtStrategy aux providers pour activer la stratégie "jwt". Contient la clé secrète du JWT pour la signature.

jwt.strategy.ts

Validation du Token

Définit la stratégie jwt, extrait le token de l'en-tête Authorization: Bearer, valide la signature et l'expiration, et attache le payload à req.user.

auth.service.ts

Logique métier

Valide les identifiants et utilise JwtService pour générer le access_token.

GET /users/profile

Ressource Protégée

Utilise le @UseGuards(JwtAuthGuard) pour rejeter tout accès sans token valide (réponse 401 Unauthorized).

🎨 Partie Frontend — Flutter (Architecture BLoC)

Le frontend utilise l'architecture BLoC pour garantir une séparation claire des préoccupations et une gestion d'état fiable.

🧱 Couches Principales

Composant

Rôle

Détail

LoginScreen & HomeScreen

Présentation (UI)

Interagit avec le Bloc (envoie des Events) et réagit aux States (met à jour l'UI, navigue).

AuthRepository

Couche de Données

Gère tous les appels HTTP vers NestJS (/auth/login, /users/profile). Contournement : utilise un stockage en mémoire pour le token.

LoginBloc

Logique Métier (BLoC)

Orchestre la logique de l'application : utilise l'AuthRepository et gère toutes les transitions d'état de la connexion.

🔄 Cycle de Vie BLoC COMPLET

Le LoginBloc gère l'état de l'utilisateur à travers les phases suivantes :

Événement

État

Fonctionnalité

LoginSubmitted

LoginLoading → LoginSuccess

Envoi des identifiants à NestJS et réception du JWT.

AppStarted

LoginSuccess 

Implémentation d'Auto-Login : vérifie la présence du token en mémoire au démarrage.

Appel Sécurisé

L'HomeScreen déclenche l'appel à /users/profile via le Repository pour récupérer les données protégées.

LoginLoggedOut

LoginInitial

Déconnexion : supprime le token de la mémoire et retourne l'utilisateur à l'écran de connexion.

✅ Validation Finale : Autorisation JWT

Le succès de l'appel à la ressource protégée (GET /users/profile) est la preuve que le système est entièrement fonctionnel :

Le token JWT est correctement généré par NestJS.

Le token JWT est correctement transmis par Flutter (en-tête Authorization: Bearer).

Le JwtAuthGuard de NestJS valide le token, le décode, et permet l'accès à la ressource.

L'application Flutter affiche le message sécurisé et les données utilisateur, confirmant l'autorisation.