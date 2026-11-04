# Mentimeeter Participant App (earlier snapshot)

Early Flutter participant app of a live quiz system (Mentimeter/Kahoot style), kept for reference.

![Flutter](https://img.shields.io/badge/Flutter-Dart%203-02569B?style=flat-square&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Status](https://img.shields.io/badge/status-Archived-lightgrey?style=flat-square)
![Team](https://img.shields.io/badge/Team%20project-2%20authors-blue?style=flat-square)

> **Superseded.** Development continued in the monorepo **[live-quiz-platform](https://github.com/Maher-bouchrara/live-quiz-platform)** (`participant-app/` folder), which replaces the mock quiz with live sessions over Firebase Realtime Database, server-side scoring, guest mode and session history. Use that repository.

## What is in this snapshot

State as of April 2026:

- Sign up / sign in with Firebase Authentication; the user is created in the GraphQL backend ([MentimeeterBackend](https://github.com/Maher-bouchrara/MentimeeterBackend)).
- Join-by-code screen (checks a fixed demo code) and waiting room.
- Timed multiple-choice questions and a final leaderboard, driven by local mock data.
- flutter_bloc state management, feature folders (`auth`, `session`, `question`, `leaderboard`).

## Run it

Prerequisites: Flutter SDK (Dart 3); the backend on port 3001 for sign-up.

```bash
flutter pub get
flutter run
```

The GraphQL URL is set in `lib/core/graphql_service.dart` (`localhost:3001`; use `10.0.2.2` on the Android emulator). The committed Firebase client config is not secret, but its API key should be restricted in the Google Cloud console.

## Author

**Maher Bouchrara** — [Portfolio](https://maher-bouchrara.vercel.app) · [GitHub](https://github.com/Maher-bouchrara) · [LinkedIn](https://www.linkedin.com/in/maher-bouchrara-35b91122b/)

Co-author: **Maher Ayachi** ([MaherAy](https://github.com/MaherAy)) — sign-up screen and Firebase Authentication integration (PR #1).
