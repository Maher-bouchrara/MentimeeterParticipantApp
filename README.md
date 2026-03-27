# Mentimeeter Participant App

Application Flutter (cote participant) inspiree d'un flow type Mentimeter:

1. Login
2. Join session (code)
3. Waiting room
4. Questions (QCM avec timer)
5. Leaderboard final

## Apercu du projet

Cette application est une base pedagogique qui illustre:

- Une architecture par features
- La gestion d'etat avec `flutter_bloc`
- Un routing simple par etats (Auth -> Session -> Question -> Leaderboard)
- Des donnees mockees pour simuler un quiz en temps reel

## Stack technique

- Flutter
- Dart
- flutter_bloc
- equatable

## Structure des dossiers

```
lib/
	core/
		mock_data.dart
		theme.dart
	features/
		auth/
			bloc/
			screens/
		session/
			bloc/
			screens/
		question/
			bloc/
			screens/
		leaderboard/
			screens/
	main.dart
```

## Flow fonctionnel

- `AuthBloc`: gere la connexion utilisateur.
- `SessionBloc`: valide le code de session et ouvre la waiting room.
- `QuestionBloc`: gere les questions, le timer, les reponses et le score.
- `LeaderboardScreen`: affiche le classement final.

Le code de session mock attendu est `AB12CD`.

## Lancer le projet

### Prerequis

- Flutter SDK installe
- Un emulator Android/iOS ou un appareil physique

### Installation

```bash
flutter pub get
```

### Execution

```bash
flutter run
```

## Qualite de code

Pour analyser le projet:

```bash
flutter analyze lib
```

## Donnees mock

Les donnees de quiz et leaderboard sont definies dans:

- `lib/core/mock_data.dart`

Tu peux modifier ce fichier pour changer:

- Le titre du quiz
- Le nombre et contenu des questions
- Les choix de reponses
- Le leaderboard final

## Notes

- Le projet est configure pour plusieurs plateformes (Android, iOS, Web, Desktop).
- Les etapes reseau/backend ne sont pas encore connectees (mode mock).

## Auteur

Maher Bouchrara
