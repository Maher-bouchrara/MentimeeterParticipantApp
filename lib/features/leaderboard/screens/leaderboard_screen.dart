import 'package:flutter/material.dart';

import '../../../core/mock_data.dart';
import '../../../core/theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({
    super.key,
    required this.playerName,
    required this.playerScore,
    this.onPlayAgain,
  });

  final String playerName;
  final int playerScore;
  final VoidCallback? onPlayAgain;

  @override
  Widget build(BuildContext context) {
    final entries = _buildSortedEntries();
    final playerIndex = entries.indexWhere((e) => e.name == playerName);
    final playerRank = playerIndex >= 0 ? playerIndex + 1 : entries.length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
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
                      title: 'Results', color: AppColors.tealDark),
                  const SizedBox(height: 22),
                  Text(
                    _rankLabel(playerRank),
                    style: const TextStyle(
                      color: AppColors.teal,
                      fontSize: 56,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$playerName - $playerScore pts',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 14),
                  ...List.generate(entries.length, (index) {
                    final entry = entries[index];
                    final isCurrentPlayer = entry.name == playerName;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${index + 1}. ${entry.name} - ${entry.score} pts',
                        style: TextStyle(
                          color: isCurrentPlayer
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontSize: 19,
                          fontWeight: isCurrentPlayer
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 18),
                  const Text(
                    'Session ended',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width:double.infinity,
                    child: ElevatedButton(onPressed: onPlayAgain, child: const Text('Join New Session')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<MockLeaderboardEntry> _buildSortedEntries() {
    final others = MockData.leaderboard
        .where((entry) => entry.name != playerName)
        .toList(growable: true);

    others.add(MockLeaderboardEntry(name: playerName, score: playerScore));
    others.sort((a, b) => b.score.compareTo(a.score));
    return others;
  }

  String _rankLabel(int rank) {
    if (rank == 1) return '1st';
    if (rank == 2) return '2nd';
    if (rank == 3) return '3rd';
    return '${rank}th';
  }
}
