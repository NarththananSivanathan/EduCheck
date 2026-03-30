# EduCheck

Application mobile de gestion des émargements pour établissements de formation.
Projet réalisé en **BTS SIO (BAC+2)** — solution full-stack combinant un backend Java Spring Boot et une application mobile Flutter.

---

## Présentation

EduCheck digitalise les feuilles de présence papier :

- Les **formateurs** déclenchent un appel en quelques secondes et valident les présences
- Les **étudiants** consultent leur taux de présence calculé côté serveur et peuvent justifier leurs absences
- Les **administrateurs** gèrent classes, étudiants et formateurs depuis un tableau de bord dédié

---

## Stack technique

| Couche | Technologies |
|---|---|
| Backend | Java 17, Spring Boot 3.2.3, Spring Data JPA, Hibernate |
| Sécurité | Spring Security, BCrypt |
| Base de données | MySQL 8 |
| Mobile | Flutter (Dart 3.3+), package HTTP |
| Build | Maven |

---

## Structure du projet

```
EduCheck/
├── api/                        # Backend Spring Boot
│   └── src/main/java/fr/esic/
│       ├── api/                # Contrôleurs REST
│       ├── entities/           # Entités JPA
│       ├── repository/         # Repositories Spring Data
│       ├── services/           # Logique métier
│       └── security/           # Configuration Spring Security
└── edu_check/                  # Application Flutter
    └── lib/
        ├── main.dart
        ├── connexion_page.dart
        ├── model/              # Modèles de données
        ├── services/           # Appels HTTP vers l'API
        └── vue/
            ├── admin/          # Interface administrateur
            ├── etudiant/       # Interface étudiant
            └── formateur/      # Interface formateur
```

---

## Modèle de données

- **User** — nom, prénom, email, mot de passe (BCrypt), rôle (FK), classe (FK)
- **Cours** — intitulé, dateCreation, dateCours, créneau (matin/après-midi), formateur (FK), classe (FK)
- **Emargement** — clé composite `(userId, coursId)`, statut de présence, justificatif, motif, horodatage
- **Classe** — nom, liste d'étudiants
- **Role** — `ETUDIANT` | `FORMATEUR` | `ADMINISTRATEUR`

---

## Fonctionnalités par rôle

### Étudiant
- Consulter ses cours
- Voir son taux de présence (calculé côté serveur)
- Soumettre une justification d'absence

### Formateur
- Déclencher un appel (création d'un cours)
- Valider les présences étudiant par étudiant
- Consulter l'historique de ses cours

### Administrateur
- Créer et gérer les classes
- Créer et gérer les comptes étudiants et formateurs
- Tableau de bord avec statistiques (nb étudiants, formateurs, classes)

---

## Prérequis

- Java 17+
- Maven 3.8+
- MySQL 8 avec une base `educheck`
- Flutter SDK 3.3+

---

## Installation & lancement

### 1. Base de données

Créer la base de données MySQL :

```sql
CREATE DATABASE educheck;
```

### 2. Backend (API Spring Boot)

```bash
cd api
mvn spring-boot:run
```

L'API démarre sur `http://localhost:8080`.
Le schéma est recréé automatiquement au démarrage (`ddl-auto=create`) avec des données de démonstration.

> **Configuration** : `api/src/main/resources/application.properties`
> Modifier l'utilisateur et le mot de passe MySQL si nécessaire.

### 3. Application Flutter

```bash
cd edu_check
flutter pub get
flutter run
```

> L'application cible `http://10.0.2.2:8080` par défaut (émulateur Android).
> Pour un appareil physique ou iOS, adapter l'URL de base dans les services.

---

## Endpoints principaux

| Méthode | Endpoint | Description |
|---|---|---|
| POST | `/login` | Authentification (email + password) |
| POST | `/user` | Création d'un utilisateur |
| GET | `/users-by-role?roleName=X` | Lister les utilisateurs par rôle |
| GET | `/cours/{formateurId}` | Cours d'un formateur |
| GET | `/cours/etudiant/{userId}` | Cours d'un étudiant |
| GET | `/presence/etudiant/{userId}` | Taux de présence d'un étudiant |
| GET | `/emargements/cours/{coursId}` | Émargements d'un cours |
| PATCH | `/emargements/{idUser}/{idCours}` | Mettre à jour un émargement |
| GET | `/count/students` | Nombre d'étudiants |
| GET | `/count/formateurs` | Nombre de formateurs |
| GET | `/count/classes` | Nombre de classes |

---

## Auteur

**BTS SIO (SLAM) 2024**
