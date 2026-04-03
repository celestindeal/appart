import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import 'package:immo_manager/core/widgets/stat_card.dart';

class BusinessDashboardPage extends ConsumerWidget {
  const BusinessDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: const [
                    StatCard(
                        icon: Icons.trending_up,
                        label: 'Revenus',
                        value: '4 200 €',
                        iconColor: AppColors.success),
                    StatCard(
                        icon: Icons.trending_down,
                        label: 'Dépenses',
                        value: '1 850 €',
                        iconColor: AppColors.error),
                    StatCard(
                        icon: Icons.account_balance,
                        label: 'Résultat Net',
                        value: '2 350 €',
                        iconColor: AppColors.primary),
                    StatCard(
                        icon: Icons.savings,
                        label: 'Trésorerie',
                        value: '15 400 €',
                        iconColor: AppColors.accent),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un Revenu'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.remove),
                    label: const Text('Ajouter une Dépense'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Navigation Cards
            Row(
              children: [
                Expanded(
                  child: _navCard(
                    context,
                    icon: Icons.receipt_long,
                    title: 'Comptabilité',
                    subtitle: 'Suivi revenus & dépenses',
                    onTap: () => context.push('/business/accounting'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _navCard(
                    context,
                    icon: Icons.contacts,
                    title: 'Contacts',
                    subtitle: 'Artisans, notaires, banques...',
                    onTap: () => context.push('/business/contacts'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            Text('Dernières Transactions', style: AppTextStyles.h4),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  _transactionTile('Loyer - Appart. Rue de Paris', '+ 850 €',
                      AppColors.success, Icons.home, '01/03/2024'),
                  const Divider(height: 1),
                  _transactionTile('Assurance PNO', '- 45 €', AppColors.error,
                      Icons.shield, '28/02/2024'),
                  const Divider(height: 1),
                  _transactionTile('Loyer - Studio Lyon', '+ 550 €',
                      AppColors.success, Icons.apartment, '01/03/2024'),
                  const Divider(height: 1),
                  _transactionTile('Taxe foncière', '- 1 200 €',
                      AppColors.error, Icons.account_balance, '15/02/2024'),
                  const Divider(height: 1),
                  _transactionTile('Plombier - Réparation', '- 180 €',
                      AppColors.error, Icons.plumbing, '10/02/2024'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(title, style: AppTextStyles.labelLarge),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: AppTextStyles.caption, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _transactionTile(
      String title, String amount, Color color, IconData icon, String date) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(date, style: AppTextStyles.caption),
      trailing:
          Text(amount, style: AppTextStyles.labelLarge.copyWith(color: color)),
    );
  }
}
