import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../../../core/theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _displayNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final displayName = _displayNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirmPassword = _confirmPasswordCtrl.text;

    if (displayName.isEmpty) {
      _showError('Veuillez entrer votre nom.');
      return;
    }
    if (email.isEmpty) {
      _showError('Veuillez entrer votre email.');
      return;
    }
    if (password.length < 6) {
      _showError('Le mot de passe doit avoir au moins 6 caracteres.');
      return;
    }
    if (password != confirmPassword) {
      _showError('Les mots de passe ne correspondent pas.');
      return;
    }

    context.read<AuthBloc>().add(SignupRequested(
          displayName: displayName,
          email: email,
          password: password,
        ));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.danger,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthAuthenticated) Navigator.of(ctx).pop();
          if (state is AuthError) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
            ));
          }
        },
        builder: (ctx, state) {
          final isLoading = state is AuthLoading;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Logo ──
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'Q',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Créer un compte',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rejoindre en tant que participant',
                      style:
                          TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 32),

                    // ── Card formulaire ──
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nom affiché',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _displayNameCtrl,
                            enabled: !isLoading,
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 14),
                            decoration:
                                const InputDecoration(hintText: 'John Doe'),
                          ),
                          const SizedBox(height: 16),

                          const Text('Adresse email',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !isLoading,
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 14),
                            decoration: const InputDecoration(
                                hintText: 'participant@example.com'),
                          ),
                          const SizedBox(height: 16),

                          const Text('Mot de passe',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _passwordCtrl,
                            obscureText: true,
                            enabled: !isLoading,
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 14),
                            decoration:
                                const InputDecoration(hintText: '••••••••'),
                          ),
                          const SizedBox(height: 16),

                          const Text('Confirmer le mot de passe',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _confirmPasswordCtrl,
                            obscureText: true,
                            enabled: !isLoading,
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 14),
                            decoration:
                                const InputDecoration(hintText: '••••••••'),
                            onSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submit,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white))
                                  : const Text('Créer mon compte'),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Center(
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              child: const Text(
                                'Déjà un compte ? Se connecter',
                                style: TextStyle(
                                    color: AppColors.accent, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
