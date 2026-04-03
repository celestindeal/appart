import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/renovation_task_entity.dart';
import '../../domain/entities/budget_item_entity.dart';

class RenovationDetailPage extends ConsumerWidget {
  final String projectId;
  const RenovationDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data
    final tasks = [
      const RenovationTaskEntity(id: '1', projectId: '1', taskName: 'Démolition cloisons', workType: WorkType.demolition, status: TaskStatus.completed, progress: 100, budgetAmount: 2000, actualCost: 1800, priority: 1),
      const RenovationTaskEntity(id: '2', projectId: '1', taskName: 'Plomberie', workType: WorkType.plumbing, status: TaskStatus.inProgress, progress: 60, budgetAmount: 4000, actualCost: 2500, priority: 2),
      const RenovationTaskEntity(id: '3', projectId: '1', taskName: 'Électricité', workType: WorkType.electrical, status: TaskStatus.pending, progress: 0, budgetAmount: 3000, actualCost: 0, priority: 3),
    ];

    final budgetItems = [
      const BudgetItemEntity(id: '1', projectId: '1', itemName: 'Carrelage', category: 'Matériaux', plannedAmount: 2500, spentAmount: 2200, supplier: 'Leroy Merlin'),
      const BudgetItemEntity(id: '2', projectId: '1', itemName: 'Main d\'oeuvre plombier', category: 'Main d\'oeuvre', plannedAmount: 3000, spentAmount: 2500),
      const BudgetItemEntity(id: '3', projectId: '1', itemName: 'Peinture', category: 'Matériaux', plannedAmount: 800, spentAmount: 0),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Détail Rénovation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Suivi Budget', style: AppTextStyles.h4),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _budgetInfo('Budget Total', '15 000 €', AppColors.textPrimary),
                        _budgetInfo('Dépensé', '8 500 €', AppColors.warning),
                        _budgetInfo('Restant', '6 500 €', AppColors.secondary),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.57,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation(AppColors.warning),
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('57% du budget utilisé', style: AppTextStyles.caption, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tasks
            Text('Tâches', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            ...tasks.map((t) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ExpansionTile(
                leading: Icon(
                  t.status == TaskStatus.completed ? Icons.check_circle : t.status == TaskStatus.inProgress ? Icons.play_circle : Icons.radio_button_unchecked,
                  color: t.status == TaskStatus.completed ? AppColors.success : t.status == TaskStatus.inProgress ? AppColors.primary : AppColors.disabled,
                ),
                title: Text(t.taskName, style: AppTextStyles.labelLarge),
                subtitle: Text('${t.progress}% • ${t.budgetAmount.toStringAsFixed(0)} €', style: AppTextStyles.caption),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Prévu: ${t.budgetAmount.toStringAsFixed(0)} €', style: AppTextStyles.bodySmall),
                            Text('Réel: ${t.actualCost.toStringAsFixed(0)} €', style: AppTextStyles.bodySmall),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: t.progress / 100,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 20),

            // Budget Breakdown
            Text('Détail Budget', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Poste')),
                    DataColumn(label: Text('Catégorie')),
                    DataColumn(label: Text('Prévu'), numeric: true),
                    DataColumn(label: Text('Dépensé'), numeric: true),
                    DataColumn(label: Text('Écart'), numeric: true),
                  ],
                  rows: budgetItems.map((item) => DataRow(cells: [
                    DataCell(Text(item.itemName)),
                    DataCell(Text(item.category ?? '-')),
                    DataCell(Text('${item.plannedAmount.toStringAsFixed(0)} €')),
                    DataCell(Text('${item.spentAmount.toStringAsFixed(0)} €')),
                    DataCell(Text(
                      '${item.ecart.toStringAsFixed(0)} €',
                      style: TextStyle(color: item.ecart >= 0 ? AppColors.success : AppColors.error),
                    )),
                  ])).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
