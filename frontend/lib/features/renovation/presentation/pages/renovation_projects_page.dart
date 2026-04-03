import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/renovation_project_entity.dart';

class RenovationProjectsPage extends ConsumerWidget {
  const RenovationProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data for now
    final projects = <RenovationProjectEntity>[
      RenovationProjectEntity(
        id: '1',
        propertyId: 'p1',
        propertyName: 'Appart. Rue de Paris',
        projectName: 'Rénovation Cuisine',
        status: RenovationStatus.inProgress,
        startDate: DateTime(2024, 3, 1),
        expectedEndDate: DateTime(2024, 6, 1),
        totalBudget: 15000,
        totalSpent: 8500,
        progress: 55,
        createdAt: DateTime.now(),
      ),
      RenovationProjectEntity(
        id: '2',
        propertyId: 'p2',
        propertyName: 'Studio Lyon',
        projectName: 'Rénovation Complète',
        status: RenovationStatus.planning,
        startDate: DateTime(2024, 5, 1),
        expectedEndDate: DateTime(2024, 9, 1),
        totalBudget: 35000,
        totalSpent: 0,
        progress: 0,
        createdAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Projets de Rénovation')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final p = projects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push('/renovations/${p.id}'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(p.projectName, style: AppTextStyles.h4),
                        ),
                        _statusBadge(p.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(p.propertyName, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Budget: ', style: AppTextStyles.labelMedium),
                        Text(
                          '${p.totalSpent.toStringAsFixed(0)} € / ${p.totalBudget.toStringAsFixed(0)} €',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: p.budgetProgress,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation(
                          p.budgetProgress > 0.9 ? AppColors.error : p.budgetProgress > 0.7 ? AppColors.warning : AppColors.secondary,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Avancement: ${p.progress}%', style: AppTextStyles.labelMedium),
                        const Spacer(),
                        Text(
                          '${p.startDate.day}/${p.startDate.month}/${p.startDate.year} → ${p.expectedEndDate.day}/${p.expectedEndDate.month}/${p.expectedEndDate.year}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nouveau Projet'),
      ),
    );
  }

  Widget _statusBadge(RenovationStatus status) {
    final (label, color) = switch (status) {
      RenovationStatus.planning => ('Planification', AppColors.info),
      RenovationStatus.inProgress => ('En cours', AppColors.secondary),
      RenovationStatus.onHold => ('En pause', AppColors.warning),
      RenovationStatus.completed => ('Terminé', AppColors.success),
      RenovationStatus.cancelled => ('Annulé', AppColors.error),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: AppTextStyles.labelSmall.copyWith(color: color)),
    );
  }
}
