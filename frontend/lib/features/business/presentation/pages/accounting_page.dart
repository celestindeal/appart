import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/accounting_entry_entity.dart';

class AccountingPage extends ConsumerStatefulWidget {
  const AccountingPage({super.key});

  @override
  ConsumerState<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends ConsumerState<AccountingPage> {
  EntryType? _filterType;

  // Mock data
  final _entries = [
    AccountingEntryEntity(id: '1', entryType: EntryType.income, amount: 850, entryDate: DateTime(2024, 3, 1), description: 'Loyer - Appart. Rue de Paris', category: ExpenseCategory.rent, propertyName: 'Appart. Rue de Paris', createdAt: DateTime.now()),
    AccountingEntryEntity(id: '2', entryType: EntryType.expense, amount: 45, entryDate: DateTime(2024, 2, 28), description: 'Assurance PNO', category: ExpenseCategory.insurance, propertyName: 'Appart. Rue de Paris', createdAt: DateTime.now()),
    AccountingEntryEntity(id: '3', entryType: EntryType.income, amount: 550, entryDate: DateTime(2024, 3, 1), description: 'Loyer - Studio Lyon', category: ExpenseCategory.rent, propertyName: 'Studio Lyon', createdAt: DateTime.now()),
    AccountingEntryEntity(id: '4', entryType: EntryType.expense, amount: 1200, entryDate: DateTime(2024, 2, 15), description: 'Taxe foncière', category: ExpenseCategory.tax, propertyName: 'Appart. Rue de Paris', createdAt: DateTime.now()),
    AccountingEntryEntity(id: '5', entryType: EntryType.expense, amount: 180, entryDate: DateTime(2024, 2, 10), description: 'Plombier - Réparation', category: ExpenseCategory.maintenance, propertyName: 'Studio Lyon', createdAt: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filterType == null ? _entries : _entries.where((e) => e.entryType == _filterType).toList();
    final totalIncome = _entries.where((e) => e.entryType == EntryType.income).fold(0.0, (sum, e) => sum + e.amount);
    final totalExpense = _entries.where((e) => e.entryType == EntryType.expense).fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comptabilité'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.file_download)),
        ],
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.surfaceVariant,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem('Revenus', '${totalIncome.toStringAsFixed(0)} €', AppColors.success),
                _summaryItem('Dépenses', '${totalExpense.toStringAsFixed(0)} €', AppColors.error),
                _summaryItem('Solde', '${(totalIncome - totalExpense).toStringAsFixed(0)} €', AppColors.primary),
              ],
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Tous'),
                  selected: _filterType == null,
                  onSelected: (_) => setState(() => _filterType = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Revenus'),
                  selected: _filterType == EntryType.income,
                  onSelected: (_) => setState(() => _filterType = _filterType == EntryType.income ? null : EntryType.income),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Dépenses'),
                  selected: _filterType == EntryType.expense,
                  onSelected: (_) => setState(() => _filterType = _filterType == EntryType.expense ? null : EntryType.expense),
                ),
              ],
            ),
          ),

          // Entries list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final e = filtered[index];
                final isIncome = e.entryType == EntryType.income;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (isIncome ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                    child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? AppColors.success : AppColors.error),
                  ),
                  title: Text(e.description, style: AppTextStyles.bodyMedium),
                  subtitle: Text('${e.category.name} • ${e.propertyName ?? ""}', style: AppTextStyles.caption),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'} ${e.amount.toStringAsFixed(0)} €',
                        style: AppTextStyles.labelLarge.copyWith(color: isIncome ? AppColors.success : AppColors.error),
                      ),
                      Text('${e.entryDate.day}/${e.entryDate.month}/${e.entryDate.year}', style: AppTextStyles.caption),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.labelLarge.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
