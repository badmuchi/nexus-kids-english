import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/audio/hybrid_audio_playback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/confetti_overlay.dart';
import '../../domain/entities/mascot_accessory_entity.dart';
import '../mascot_wardrobe_bloc.dart';
import '../mascot_wardrobe_event.dart';
import '../mascot_wardrobe_state.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MascotWardrobeBloc>().add(const LoadWardrobeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Достижения и Бейджи'),
      ),
      body: BlocBuilder<MascotWardrobeBloc, MascotWardrobeState>(
        builder: (context, state) {
          return switch (state) {
            MascotWardrobeInitial() || MascotWardrobeLoading() =>
              const Center(child: CircularProgressIndicator()),
            MascotWardrobeErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            MascotWardrobeLoaded(badges: final list) => _buildBadgesGrid(context, list),
          };
        },
      ),
    );
  }

  void _showBadgeCelebrationDialog(BuildContext context, BadgeEntity badge) {
    if (badge.isUnlocked) {
      try {
        context.read<HybridAudioPlaybackService>().playBadgeEarnedSound();
      } catch (_) {}
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return ConfettiOverlay(
          isPlaying: badge.isUnlocked,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                Text(badge.isUnlocked ? badge.emoji : '🔒', style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    badge.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  badge.description,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: badge.isUnlocked
                        ? AppTheme.accentColor.withValues(alpha: 0.15)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge.isUnlocked
                        ? '🎉 Награда разблокирована! Отличная работа!'
                        : '🔒 Продолжай тренировки, чтобы открыть этот бейдж!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: badge.isUnlocked ? const Color(0xFFB45309) : Colors.grey.shade700,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Супер!'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadgesGrid(BuildContext context, List<BadgeEntity> badges) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return Card(
          elevation: badge.isUnlocked ? 3 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: badge.isUnlocked ? AppTheme.accentColor : Colors.grey.shade300,
              width: badge.isUnlocked ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => _showBadgeCelebrationDialog(context, badge),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: badge.isUnlocked
                          ? AppTheme.accentColor.withValues(alpha: 0.15)
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        badge.isUnlocked ? badge.emoji : '🔒',
                        style: TextStyle(fontSize: badge.isUnlocked ? 30 : 24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    badge.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: badge.isUnlocked ? const Color(0xFF1E293B) : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    badge.description,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: badge.isUnlocked ? Colors.grey.shade600 : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
