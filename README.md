# ImmoManager

Application de gestion d'entreprise immobiliere. Recherche de biens, gestion des achats, suivi des renovations, gestion des locataires et comptabilite - le tout dans une seule application multi-plateforme.

## Fonctionnalites

| Module | Description |
|--------|-------------|
| **Recherche de biens** | Recherche, fiches detaillees, calculateur de rentabilite (brut, net, cash-flow, mensualite credit) |
| **Gestion d'achat** | Pipeline d'acquisition avec jalons (visite, offre, financement, notaire), suivi financier |
| **Renovation** | Planning des travaux par corps de metier, suivi budget previsionnel vs reel, progression |
| **Locataires** | Suivi complet des locataires, paiements de loyer, documents joints (bail, quittances...), rappels automatiques |
| **Gestion d'entreprise** | Comptabilite (revenus/depenses par bien), carnet de contacts professionnels |
| **Authentification** | Inscription, connexion, JWT + refresh tokens |

## Architecture

Monorepo avec deux parties clairement separees :

```
immo-manager/
├── frontend/                         # Frontend Flutter
│   ├── lib/
│   │   ├── config/                   # Theme, couleurs, routes, constantes
│   │   ├── core/                     # Reseau, services, widgets partages, extensions
│   │   └── features/                 # Modules metier (clean architecture)
│   │       ├── auth/                 #   Authentification
│   │       ├── dashboard/            #   Tableau de bord
│   │       ├── properties/           #   Biens immobiliers
│   │       ├── purchase/             #   Projets d'achat
│   │       ├── renovation/           #   Travaux
│   │       ├── tenants/              #   Locataires
│   │       └── business/             #   Comptabilite & contacts
│   ├── assets/                       # Images, icones, polices (Poppins)
│   └── pubspec.yaml                  # Dependances Flutter
├── backend/                          # Backend .NET 8
│   └── src/
│       ├── ImmoManager.Domain/           # Entites, enums, interfaces repos
│       ├── ImmoManager.Application/      # DTOs, interfaces services
│       ├── ImmoManager.Infrastructure/   # EF Core, auth JWT, implementations
│       └── ImmoManager.Api/              # Controllers REST, Swagger
└── README.md
```

Chaque feature Flutter suit le pattern **Clean Architecture** :
- `data/` : modeles JSON, datasources, implementation des repositories
- `domain/` : entites metier, interfaces repositories, use cases
- `presentation/` : pages, widgets, providers Riverpod

## Stack technique

| Couche | Technologie |
|--------|-------------|
| Frontend | Flutter 3.38+, Dart 3.10+ |
| State management | Riverpod |
| Navigation | GoRouter |
| HTTP client | Dio |
| Backend | .NET 8 Web API |
| ORM | Entity Framework Core 8 |
| Base de donnees | SQLite (dev) - migrable vers PostgreSQL/SQL Server |
| Authentification | JWT + refresh tokens (BCrypt) |
| Documentation API | Swagger / OpenAPI |

## Pre-requis

Avant de commencer, installe les outils suivants :

- **Flutter SDK** >= 3.0 : [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- **.NET 8 SDK** : [dotnet.microsoft.com/download/dotnet/8.0](https://dotnet.microsoft.com/download/dotnet/8.0)
- **Git**
- Un editeur : VS Code (recommande) ou Android Studio
- **DBeaver** (optionnel) : pour visualiser la base de donnees SQLite

## Installation

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd immo-manager
```

### 2. Installer le frontend Flutter

```bash
cd frontend
flutter pub get
cd ..
```

### 3. Installer le backend .NET

```bash
cd backend

# Restaurer les packages NuGet
dotnet restore

# Installer l'outil EF Core CLI (une seule fois)
dotnet tool install --global dotnet-ef

# Creer la base de donnees et appliquer les migrations
dotnet ef database update \
  --project src/ImmoManager.Infrastructure \
  --startup-project src/ImmoManager.Api

cd ..
```

La base de donnees SQLite sera creee dans `backend/src/ImmoManager.Api/ImmoManager.db`.

## Lancement

### Lancer le backend (API)

```bash
cd backend/src/ImmoManager.Api
dotnet run
```

L'API demarre sur `http://localhost:5000`. L'interface Swagger est disponible sur `http://localhost:5000/swagger` en mode developpement.

### Lancer le frontend Flutter

Dans un autre terminal :

```bash
cd frontend

# Sur Windows (desktop)
flutter run -d windows

# Sur navigateur web
flutter run -d chrome

# Sur Android (emulateur ou appareil connecte)
flutter run -d android

# Lister les appareils disponibles
flutter devices
```

## Voir la base de donnees avec DBeaver

1. Ouvre DBeaver
2. Nouvelle connexion > **SQLite**
3. Chemin du fichier : `backend/src/ImmoManager.Api/ImmoManager.db`
4. Clic sur **Tester la connexion** puis **OK**

Tu auras acces a toutes les tables : Users, Properties, Tenants, RentPayments, RenovationProjects, AccountingEntries, Contacts, etc.

## Structure de la base de donnees

16 tables principales :

| Table | Description |
|-------|-------------|
| `Users` | Comptes utilisateurs |
| `RefreshTokens` | Tokens de rafraichissement JWT |
| `Properties` | Biens immobiliers |
| `PropertyDocuments` | Documents lies aux biens |
| `PropertyExpenses` | Depenses par bien |
| `PurchaseProjects` | Projets d'acquisition |
| `PurchaseMilestones` | Jalons des projets d'achat |
| `RenovationProjects` | Projets de renovation |
| `RenovationTasks` | Taches de renovation |
| `BudgetItems` | Lignes budgetaires renovation |
| `Tenants` | Locataires |
| `TenantDocuments` | Documents des locataires |
| `RentPayments` | Paiements de loyer |
| `Reminders` | Rappels et alertes |
| `AccountingEntries` | Ecritures comptables |
| `Contacts` | Carnet de contacts pro |

## Endpoints API

| Methode | Route | Description |
|---------|-------|-------------|
| POST | `/api/auth/register` | Inscription |
| POST | `/api/auth/login` | Connexion |
| POST | `/api/auth/refresh` | Rafraichir le token |
| GET/POST | `/api/properties` | Liste / Creer un bien |
| GET/PUT/DELETE | `/api/properties/{id}` | Detail / Modifier / Supprimer |
| POST | `/api/properties/calculate-profitability` | Calculer la rentabilite |
| GET/POST | `/api/tenants` | Liste / Creer un locataire |
| GET/POST | `/api/tenants/{id}/payments` | Paiements d'un locataire |
| GET/POST | `/api/tenants/{id}/documents` | Documents d'un locataire |
| GET/POST | `/api/tenants/{id}/reminders` | Rappels d'un locataire |
| GET/POST | `/api/purchases` | Projets d'achat |
| GET/POST | `/api/renovations` | Projets de renovation |
| GET/POST | `/api/renovations/{id}/tasks` | Taches de renovation |
| GET/POST | `/api/renovations/{id}/budget-items` | Budget renovation |
| GET/POST | `/api/accounting` | Ecritures comptables |
| GET | `/api/accounting/summary` | Resume financier |
| GET/POST | `/api/contacts` | Contacts professionnels |

Consulte le Swagger (`/swagger`) pour le detail complet des requetes et reponses.

## Commandes utiles

```bash
# Analyser le code Flutter
cd frontend && flutter analyze

# Lancer les tests Flutter
cd frontend && flutter test

# Build release Windows
cd frontend && flutter build windows

# Build APK Android
cd frontend && flutter build apk

# Build backend en release
cd backend && dotnet publish -c Release

# Ajouter une migration apres modification des entites
cd backend && dotnet ef migrations add NomDeLaMigration \
  --project src/ImmoManager.Infrastructure \
  --startup-project src/ImmoManager.Api
```

## Licence

Projet prive.
