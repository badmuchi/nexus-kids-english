import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/mascot_accessory_entity.dart';
import '../mascot_wardrobe_bloc.dart';
import '../mascot_wardrobe_event.dart';
import '../mascot_wardrobe_state.dart';

class MascotWardrobeScreen extends StatefulWidget {
  const MascotWardrobeScreen({super.key});

  @override
  State<MascotWardrobeScreen> createState() => _MascotWardrobeScreenState();
}

class _MascotWardrobeScreenState extends State<MascotWardrobeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MascotWardrobeBloc>().add(const LoadWardrobeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🦊 Гардероб Спарки'),
      ),
      body: BlocBuilder<MascotWardrobeBloc, MascotWardrobeState>(
        builder: (context, state) {
          return switch (state) {
            MascotWardrobeInitial() || MascotWardrobeLoading() =>
              const Center(child: CircularProgressIndicator()),
            MascotWardrobeErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            MascotWardrobeLoaded() => _buildWardrobeBody(context, state),
          };
        },
      ),
    );
  }

  Widget _buildWardrobeBody(BuildContext context, MascotWardrobeLoaded state) {
    final equipped = state.equippedItem;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mascot Avatar preview card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8A00), Color(0xFFE52E71)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8A00).withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('🦊', style: TextStyle(fontSize: 60)),
                        ),
                      ),
                      if (equipped != null)
                        Positioned(
                          top: 0,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Text(equipped.emoji, style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Лисёнок Спарки',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    equipped != null ? 'Надето: ${equipped.name} ${equipped.emoji}' : 'Без аксессуаров',
                    style: const TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Аксессуары за XP:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.accessories.length,
            itemBuilder: (context, index) {
              final acc = state.accessories[index];
              return _buildAccessoryTile(context, acc);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccessoryTile(BuildContext context, MascotAccessoryEntity item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: item.isEquipped ? AppTheme.primaryColor : Colors.grey.shade200,
          width: item.isEquipped ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
          ),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(item.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        trailing: item.isUnlocked
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.isEquipped ? Colors.grey.shade200 : AppTheme.primaryColor,
                  foregroundColor: item.isEquipped ? Colors.grey.shade800 : Colors.white,
                  elevation: item.isEquipped ? 0 : 2,
                ),
                onPressed: () {
                  context.read<MascotWardrobeBloc>().add(EquipAccessoryEvent(item.id));
                },
                child: Text(item.isEquipped ? 'Снять' : 'Надеть'),
              )
            : OutlinedButton.icon(
                icon: const Icon(Icons.lock_open, size: 16),
                label: Text('${item.costXp} XP'),
                onPressed: () {
                  context.read<MascotWardrobeBloc>().add(UnlockAccessoryEvent(item.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🎉 Открыт аксессуар: ${item.name}!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
