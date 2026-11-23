import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/ib_unit_entity.dart';
import '../ib_bloc.dart';
import '../ib_state.dart';
import 'ib_unit_detail_screen.dart';

class IbUnitsScreen extends StatelessWidget {
  const IbUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IB MYP • Language Acquisition'),
      ),
      body: BlocBuilder<IbBloc, IbState>(
        builder: (context, state) {
          return switch (state) {
            IbInitial() || IbLoading() => const Center(child: CircularProgressIndicator()),
            IbErrorState(message: final m) => Center(child: Text('Ошибка: $m')),
            IbLoaded(units: final list) => _buildUnitsList(context, list),
          };
        },
      ),
    );
  }

  Widget _buildUnitsList(BuildContext context, List<IbInquiryUnitEntity> units) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        final totalTasks = unit.criteriaTasks.length;
        final progress = totalTasks > 0 ? (unit.completedTasksCount / totalTasks).clamp(0.0, 1.0) : 0.0;

        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => IbUnitDetailScreen(unit: unit)),
              );
            },
            borderRadius: BorderRadius.circular(18),
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
                          color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          unit.phase,
                          style: const TextStyle(
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        unit.globalContext,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    unit.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    unit.statementOfInquiry,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Выполнено заданий: ${unit.completedTasksCount}/$totalTasks',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
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
