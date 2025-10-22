# 🧩 Rociny Login Case — Afrid Azar

Cas pratique technique réalisé pour l’application **Rociny**.  
L’objectif : reproduire l’UI de **login** avec **Flutter (frontend)** et **NestJS (backend)**, en respectant les bonnes pratiques (BLoC, JWT, architecture modulaire).

---

## 📁 Structure du projet

rociny-login-case/
│
├── backend/ ← API NestJS (authentification, JWT)
│ ├── src/
│ │ ├── auth/ ← Module d’authentification
│ │ └── main.ts
│ ├── package.json
│ └── tsconfig.json
│
└── frontend/ ← App Flutter (UI, logique login)
├── lib/
│ ├── blocs/ ← Gestion d’état (BLoC)
│ ├── screens/ ← Interface utilisateur
│ └── main.dart
├── pubspec.yaml
└── ...


---

## 🧠 Partie Backend — NestJS

### 🎯 Objectif
Mettre en place un système d’authentification simple basé sur **JWT**, avec une **base de données simulée en mémoire (RAM)**.

---

### 🔐 Authentification (`src/auth/`)

#### 📦 `auth.module.ts`
Ce module regroupe toute la logique d’authentification.  
Il importe le `JwtModule`, enregistre le `AuthService` et le `AuthController`, puis l’intègre dans l’application principale (`app.module.ts`).

> C’est ce module qui rend les routes `/auth/...` accessibles.

---

#### ⚙️ `auth.service.ts`
Ce service contient la logique métier principale du login :

- Simule une **base d’utilisateurs en mémoire** :
  ```ts
  private users = [
    { id: 1, email: 'afrid.azar@gmail.com', password: 'afrid' },
  ];

    Vérifie les identifiants via validateUser(email, password)

    Si la connexion est valide :

        Crée un payload JWT :

        const payload = { email: user.email, sub: user.id };

        Génère un token JWT grâce à JwtService

    Retourne ce token au contrôleur

    💡 Cette approche simule un vrai login sécurisé, sans base de données réelle.

🚪 auth.controller.ts

C’est ici que la route POST /auth/login est définie.

    Elle reçoit les données du formulaire :

{
  "email": "afrid.azar@gmail.com",
  "password": "afrid"
}

Appelle le service AuthService pour valider l’utilisateur.

Renvoie un token JWT si les identifiants sont corrects :

    {
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }

    En cas d’erreur, elle renvoie une réponse 401 Unauthorized.

🧱 main.ts

Point d’entrée de l’application NestJS.
Il initialise le serveur et lance l’application sur http://localhost:3000

.
🧪 Test du login via Postman

Requête :

POST http://localhost:3000/auth/login

Headers :

{ "Content-Type": "application/json" }

Body :

{
  "email": "afrid.azar@gmail.com",
  "password": "afrid"
}

Réponse attendue :

{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}