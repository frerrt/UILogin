Rociny Login Case — Afrid Azar

Ce projet met en œuvre un système d'authentification complet basé sur les bonnes pratiques du développement Full-Stack : Flutter (Frontend) pour l'interface utilisateur avec l'architecture BLoC, et NestJS (Backend) pour l'API et la gestion du JWT.

I. Structure du Projet et Démarrage

Le projet est organisé autour des deux composantes principales pour une architecture Full-Stack modulaire.

1. Structure des Répertoires

rociny-login-case/
│
├── backend/             ← API NestJS (Authentification, JWT, Ressources Sécurisées)
│ ├── src/
│ │ ├── auth/                 ← Modules d'Auth, Controller, Service, Stratégie JWT
│ │ ├── auth/strategy/        ← Contient jwt.strategy.ts
│ │ ├── users/                ← Contient la ressource protégée (/users/profile)
│ │ └── main.ts
│ └── ...
│
└── frontend/           ← Application Flutter (UI, Logique de connexion BLoC)
    ├── lib/
    │   ├── auth/             ← Contient Bloc, Events, States et Repository
    │   ├── screens/          ← LoginScreen, HomeScreen
    │   └── main.dart
    └── ...



2. Démarrage Rapide

Identifiants de Démonstration Valides :
Email : test@rociny.com / Mot de passe : test

Composant

Répertoire

Commandes

Détails

Backend (NestJS)

cd backend

npm install puis npm run start:dev

URL de connexion : POST /auth/login

Frontend (Flutter)

cd ../frontend

flutter pub get puis flutter run

Ressource sécurisée : GET /users/profile

II. Partie Backend — NestJS

Objectif : Mettre en place un système d’authentification JWT fonctionnel, incluant la génération et la validation du token, ainsi que la protection d'une ressource.

Architecture d'Authentification

Fichier/Composant

Rôle:

   Logique Clé:

auth.module.ts

Configuration

Importe PassportModule, ajoute JwtStrategy aux providers, et configure le secret pour la signature du JWT.

-> jwt.strategy.ts

Validation du Token

Définit la stratégie jwt, extrait, valide la signature du token et attache le payload à req.user.

-> auth.service.ts

Logique métier

Valide les identifiants de démonstration et utilise JwtService pour générer l'access_token.

GET /users/profile

Ressource Protégée

Utilise le @UseGuards(JwtAuthGuard) pour rejeter toute requête dont le JWT est manquant ou invalide (réponse 401 Unauthorized).

III. Partie Frontend — Flutter (Architecture BLoC)

Le frontend utilise l'architecture BLoC pour garantir une séparation claire des préoccupations et une gestion d'état fiable.

Couches Principales

Composant

Rôle

Détail

LoginScreen & HomeScreen

Présentation (UI)

Interagissent avec le Bloc (envoient des Events) et réagissent aux States (mettent à jour l'UI, gèrent la navigation).

AuthRepository

Couche de Données

Gère les appels HTTP vers NestJS (/auth/login, /users/profile). 

Règle de Sécurité (Production) : Dans une application réelle, stocker le token en mémoire (RAM) est une faille de sécurité, car le jeton est perdu si l'application est fermée et n'est pas protégé contre certaines attaques. Il faudrait utiliser Flutter Secure Storage.

remarque : Le stockage du token est volatil (en mémoire), conformément aux spécifications du challenge. Pour la production, une solution sécurisée et persistante (ex: Flutter Secure Storage) serait requise.


LoginBloc

Logique Métier (BLoC)

Orchestre la logique de l'application : utilise l'AuthRepository et gère toutes les transitions d'état de la connexion.

Cycle de Vie BLoC Complet (Exemples de Transitions)

Le LoginBloc gère l'état de l'utilisateur à travers les phases suivantes :

Événement

État

Fonctionnalité

LoginSubmitted

LoginLoading → LoginSuccess

Envoi des identifiants à NestJS, réception et stockage du JWT.

AppStarted

LoginSuccess ou LoginInitial

Auto-Login : Vérifie la présence du token en mémoire au démarrage de l'application.

Appel Sécurisé

L'HomeScreen déclenche l'appel à /users/profile via le Repository pour récupérer les données protégées.

LoginLoggedOut

LoginInitial

Déconnexion : Supprime le token de la mémoire et retourne l'utilisateur à l'écran de connexion.

IV. Validation Finale : Autorisation JWT

Le succès de l'appel à la ressource protégée (GET /users/profile) est la preuve que le système est entièrement fonctionnel :

Le token JWT est correctement généré par NestJS.

Le token JWT est correctement transmis par Flutter (en-tête Authorization: Bearer).

Le JwtAuthGuard de NestJS valide le token, le décode, et permet l'accès à la ressource.

L'application Flutter affiche le message sécurisé et les données utilisateur, confirmant l'autorisation.