import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
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
        );
      },
    );
  }
}
