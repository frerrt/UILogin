# Rociny Login Case

Ce projet est un cas pratique pour l'application **Rociny**.  
L'objectif est de reproduire l'UI de login avec Flutter (frontend) et NestJS (backend), en utilisant des bonnes pratiques modernes.

---

## 📂 Structure du projet

rociny-login-case/
│
├── backend/ ← projet NestJS
│ ├── src/
│ │ ├── auth/ ← module login + JWT
│ │ └── main.ts
│ ├── package.json
│ └── tsconfig.json
│
└── frontend/ ← projet Flutter
├── lib/
│ ├── blocs/ ← BLoC login
│ ├── screens/
│ └── main.dart
├── pubspec.yaml
└── ...


---

## 🛠️ Prérequis

### Backend (NestJS)
- Node.js LTS installé
- Nest CLI (`npm i -g @nestjs/cli`)
- Postman ou Insomnia pour tester l'API

### Frontend (Flutter)
- Flutter installé (`flutter doctor`)
- IDE (VS Code ou Android Studio)
- Simulateur ou appareil pour tester

---

## 🚀 Lancer le projet

### Backend
```bash
cd backend
npm install
npm run start:dev

Frontend

cd frontend
flutter pub get
flutter run

🎯 Objectif du projet
Frontend (Flutter)

    UI login

    Gestion d'état avec BLoC

    Requête API pour login

    Gestion du JWT

Backend (NestJS)

    Route /login

    Validation email/password

    Génération JWT

    Base de données simulée en RAM

📝 Notes

    Ce projet est destiné à un cas pratique pour l'entretien technique Rociny.

    Des améliorations comme validation des champs, messages d’erreur ou loaders peuvent être ajoutées pour démontrer les bonnes pratiques.


---

