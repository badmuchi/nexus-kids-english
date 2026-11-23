import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/study_goal_entity.dart';
import '../goals_bloc.dart';
import '../goals_state.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои цели и трекер ОГЭ / IB'),
      ),
      body: BlocBuilder<GoalsBloc, GoalsState>(
        builder: (context, state) {
          return switch (state) {
            GoalsInitial() || GoalsLoading() => const Center(child: CircularProgressIndicator()),
            GoalsErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            GoalsLoaded(goals: final list) => _buildGoalsList(context, list),
          };
        },
      ),
    );
  }

  Widget _buildGoalsList(BuildContext context, List<StudyGoalEntity> goals) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        final isOge = goal.category == 'OGE';

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isOge ? AppTheme.primaryColor : AppTheme.accentColor).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        goal.category,
                        style: TextStyle(
                          color: isOge ? AppTheme.primaryColor : AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      'Осталось: ${goal.deadlineDays} дней',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  goal.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  goal.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Прогресс: ${goal.currentValue} из ${goal.targetValue} ${goal.unit}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${goal.progressPercent}%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isOge ? AppTheme.primaryColor : AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: goal.progressFraction,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOge ? AppTheme.primaryColor : AppTheme.accentColor,
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
