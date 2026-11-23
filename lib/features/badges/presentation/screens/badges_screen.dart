import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/badge_entity.dart';
import '../badges_bloc.dart';
import '../badges_state.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  IconData _getIconData(String name) {
    return switch (name) {
      'gps_fixed' => Icons.gps_fixed,
      'auto_awesome' => Icons.auto_awesome,
      'record_voice_over' => Icons.record_voice_over,
      'psychology' => Icons.psychology,
      'local_fire_department' => Icons.local_fire_department,
      'border_color' => Icons.border_color,
      _ => Icons.military_tech,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Коллекция ачивок и наград'),
      ),
      body: BlocBuilder<BadgesBloc, BadgesState>(
        builder: (context, state) {
          return switch (state) {
            BadgesInitial() || BadgesLoading() => const Center(child: CircularProgressIndicator()),
            BadgesErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            BadgesLoaded() => _buildBadgesGrid(context, state),
          };
        },
      ),
    );
  }

  Widget _buildBadgesGrid(BuildContext context, BadgesLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, size: 48, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Твои трофеи',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Разблокировано: ${state.unlockedCount} из ${state.badges.length}',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.badges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final badge = state.badges[index];
              return _buildBadgeCard(badge);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(BadgeEntity badge) {
    final iconData = _getIconData(badge.icon);

    return Card(
      color: badge.isUnlocked ? Colors.white : const Color(0xFFF1F5F9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: badge.isUnlocked ? AppTheme.accentColor.withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
          width: badge.isUnlocked ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? AppTheme.accentColor.withValues(alpha: 0.15)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: badge.isUnlocked ? AppTheme.accentColor : Colors.grey,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: badge.isUnlocked ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                badge.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: badge.isUnlocked ? Colors.grey.shade700 : Colors.grey.shade500,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
