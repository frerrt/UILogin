Rociny Login Case — Afrid Azar
Ce projet met en œuvre un système d'authentification complet Full-Stack utilisant Flutter (Frontend) avec l'architecture BLoC, et NestJS (Backend) pour l'API et la gestion du JWT.
🔑 Identifiants de Démonstration
Veuillez utiliser ces identifiants pour tester la connexion et l'accès à la ressource protégée :
Champ                             Valeur
Email                             test@rociny.com
Mot de passe                      password

🛠️ Démarrage et Installation
Le projet nécessite de lancer indépendamment les composants Backend (NestJS) et Frontend (Flutter).

1. Backend (API NestJS)

Action          Répertoire         Commandes            Détails
Installation    cd backend         npm install          Installe les dépendances Node.js.
Lancement       cd backend         npm run start:dev    Démarre le serveur en mode développement.
Route d'Auth    N/A                N/A                  URL de connexion : POST http://localhost:3000/auth/login

2. Frontend (Application Flutter)

Action          Répertoire          Commandes           Détails
Installation    cd frontend         flutter pub get     Récupère les dépendances Dart.
Lancement       cd frontend         flutter run         Démarre l'application sur l'émulateur/appareil.
Route Sécurisée N/A                 N/A                 La connexion réussie mène à la ressource protégée : GET /users/profile

🧠 Architecture du Projet
Structure des Répertoires
rociny-login-case/
│
├── backend/             
│ ├── src/
│ │ ├── auth/                 ← Modules d'Auth, Stratégie JWT
│ │ └── users/                ← Ressource protégée
│
└── frontend/           
    ├── lib/
    │   ├── auth/             ← Bloc, Events, States et Repository (BLoC)
    │   └── screens/          ← LoginScreen, HomeScreen (UI)


Détails Techniques Clés :

Composant                 Rôle Principal             Note d'Implémentation
LoginBloc (Flutter)       Logique Métier             Gère le cycle de vie complet de l'utilsateur (connexion,déconnexion,auto-login)                                          via des Events et des States.
                                                   
AuthRepository (Flutter)  Couche de Données          Gère les appels HTTP vers NestJS. Note Sécurité  : Le stockage du token est
                                                     volatil (en mémoire),conformément aux spécifications du challenge (pour la production,une solution sécurisée comme Flutter Secure Storage serait requise).

jwt.strategy.ts (NestJS) Autorisation JWT            Définit la stratégie jwt et valide le token envoyé dans l'en-tête    
                                                     Authorization: Bearer.

@UseGuards (NestJS)      Protection Ressource        Rejette toute requête dont le JWT est manquant ou invalide, renvoyant un 401
                                                     Unauthorized pour la route /users/profile.


✅ Améliorations UX (Ajout au-delà des exigences)
Pour améliorer l'ergonomie et la praticité du formulaire de connexion, j'ai ajouté la fonctionnalité de basculement de la visibilité du mot de passe (Icône en œil dans le LoginScreen).
Ceci démontre une attention particulière à l'expérience utilisateur et aux bonnes pratiques de conception d'interfaces.

✅ Feuille de Route (Améliorations Futures)

Afin d'offrir plus de flexibilité aux utilisateurs, la connexion par des fournisseurs d'identité tiers (Single Sign-On / Social Login) est envisagable :

Intégration de Google Sign-In pour une connexion rapide.

Intégration d'Amazon Sign-In (ou Apple Sign-In) pour élargir les options.
Ces fonctionnalités nécessiteront l'intégration de SDKs spécifiques côté Frontend (Flutter) et la configuration d'un flux OAuth sécurisé côté Backend (NestJS).