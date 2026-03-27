import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class WaitingRoomScreen extends StatefulWidget {
  const WaitingRoomScreen({
    super.key,
    this.sessionTitle = 'JavaScript Basics',
    this.joinedPlayers = 4,
    this.onHostStarted,
    this.hostStartDelay = const Duration(seconds: 2),
  });

  final String sessionTitle;
  final int joinedPlayers;
  final VoidCallback? onHostStarted;
  final Duration hostStartDelay;

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    _scheduleHostStart();
  }

  @override
  void didUpdateWidget(covariant WaitingRoomScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onHostStarted == null && widget.onHostStarted != null) {
      _scheduleHostStart();
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    super.dispose();
  }

  void _scheduleHostStart() {
    _startTimer?.cancel();
    if (widget.onHostStarted == null) return;
    _startTimer = Timer(widget.hostStartDelay, () {
      if (!mounted) return;
      widget.onHostStarted?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const ScreenHeader(
                    title: 'Waiting Room',
                    color: AppColors.tealDark,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.sessionTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.joinedPlayers} players joined',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 92,
                    height: 92,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.teal,
                        ),
                        Text(
                          'Wait...',
                          style: TextStyle(
                            color: AppColors.teal,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Host will start soon',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
