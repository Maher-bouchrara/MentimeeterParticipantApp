import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/graphql_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(_initialState()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<GuestJoinRequested>(_onGuestJoinRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthRequested>(_onCheckAuthRequested);

    if (state is AuthAuthenticated) {
      add(const CheckAuthRequested());
    }
  }

  static AuthState _initialState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthAuthenticated(
        displayName: user.displayName ?? user.email ?? '',
        email: user.email,
        userId: null,
      );
    }
    return const AuthInitial();
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final firebaseUid = credential.user?.uid;
      final email = credential.user?.email ?? event.email;
      final displayName =
          credential.user?.displayName ?? email.split('@').first;

      final userId = await GraphQLService.instance
          .getUserIdByFirebaseUid(firebaseUid ?? '');

      emit(AuthAuthenticated(
        displayName: displayName,
        email: email,
        userId: userId,
      ));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _mapLoginError(e.code)));
    } catch (_) {
      emit(const AuthError(message: 'Erreur inattendue, veuillez reessayer.'));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await credential.user?.updateDisplayName(event.displayName);

      final firebaseUid = credential.user?.uid;
      final userId = await GraphQLService.instance.createUser(
        displayName: event.displayName,
        firebaseUid: firebaseUid,
        role: 'user',
      );

      if (userId == null) {
        emit(const AuthError(
            message: 'Impossible de creer le compte dans la base de donnees.'));
        return;
      }

      emit(AuthAuthenticated(
        displayName: event.displayName,
        email: credential.user?.email ?? event.email,
        userId: userId,
      ));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _mapSignupError(e.code)));
    } catch (e) {
      emit(AuthError(message: 'Erreur: ${e.toString()}'));
    }
  }

  Future<void> _onGuestJoinRequested(
    GuestJoinRequested event,
    Emitter<AuthState> emit,
  ) async {
    final name = event.displayName.trim();
    if (name.isEmpty) {
      emit(const AuthError(message: 'Veuillez entrer votre nom.'));
      return;
    }

    emit(const AuthLoading());
    try {
      final userId = await GraphQLService.instance.createUser(
        displayName: name,
        role: 'guest',
      );

      emit(AuthAuthenticated(
        displayName: name,
        userId: userId,
        isGuest: true,
      ));
    } catch (_) {
      // Fallback: allow guest mode even without backend
      emit(AuthAuthenticated(
        displayName: name,
        isGuest: true,
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final current = state;
    if (current is AuthAuthenticated && !current.isGuest) {
      await FirebaseAuth.instance.signOut();
    }
    emit(const AuthInitial());
  }

  Future<void> _onCheckAuthRequested(
    CheckAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;
    if (currentState.userId != null) return;
    if (currentState.isGuest) return;

    final firebaseUid = FirebaseAuth.instance.currentUser?.uid;
    if (firebaseUid == null) {
      emit(const AuthInitial());
      return;
    }

    try {
      final userId =
          await GraphQLService.instance.getUserIdByFirebaseUid(firebaseUid);
      if (userId != null) {
        emit(AuthAuthenticated(
          displayName: currentState.displayName,
          email: currentState.email,
          userId: userId,
        ));
      }
    } catch (_) {}
  }

  String _mapLoginError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'user-not-found':
        return 'Aucun utilisateur trouve avec cet email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      case 'too-many-requests':
        return 'Trop de tentatives. Reessayez plus tard.';
      case 'network-request-failed':
        return 'Probleme reseau. Verifiez votre connexion.';
      default:
        return 'Connexion impossible ($code).';
    }
  }

  String _mapSignupError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'email-already-in-use':
        return 'Cet email est deja utilise.';
      case 'weak-password':
        return 'Le mot de passe doit avoir au moins 6 caracteres.';
      case 'operation-not-allowed':
        return 'La creation de compte est desactivee.';
      case 'network-request-failed':
        return 'Probleme reseau. Verifiez votre connexion.';
      default:
        return 'Erreur lors de la creation du compte ($code).';
    }
  }
}
