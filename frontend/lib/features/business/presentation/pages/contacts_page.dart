import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/contact_entity.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  ContactType? _filterType;
  String _search = '';

  final _contacts = [
    ContactEntity(id: '1', name: 'Jean Dupont', contactType: ContactType.contractor, companyName: 'Dupont Plomberie', phoneNumber: '06 12 34 56 78', email: 'jean@dupont.fr', createdAt: DateTime.now()),
    ContactEntity(id: '2', name: 'Marie Martin', contactType: ContactType.solicitor, companyName: 'Cabinet Martin', phoneNumber: '01 23 45 67 89', email: 'marie@martin.fr', createdAt: DateTime.now()),
    ContactEntity(id: '3', name: 'Pierre Durand', contactType: ContactType.realEstateAgent, companyName: 'Immo Plus', phoneNumber: '06 98 76 54 32', email: 'pierre@immoplus.fr', createdAt: DateTime.now()),
    ContactEntity(id: '4', name: 'Sophie Blanc', contactType: ContactType.banker, companyName: 'BNP Paribas', phoneNumber: '01 11 22 33 44', createdAt: DateTime.now()),
    ContactEntity(id: '5', name: 'Luc Moreau', contactType: ContactType.accountant, companyName: 'Cabinet Moreau', phoneNumber: '06 55 44 33 22', email: 'luc@moreau.fr', createdAt: DateTime.now()),
  ];

  String _typeLabel(ContactType type) => switch (type) {
    ContactType.contractor => 'Artisan',
    ContactType.solicitor => 'Notaire',
    ContactType.realEstateAgent => 'Agent immo',
    ContactType.banker => 'Banquier',
    ContactType.accountant => 'Comptable',
    ContactType.tenant => 'Locataire',
    ContactType.supplier => 'Fournisseur',
    ContactType.other => 'Autre',
  };

  @override
  Widget build(BuildContext context) {
    var filtered = _contacts.toList();
    if (_filterType != null) {
      filtered = filtered.where((c) => c.contactType == _filterType).toList();
    }
    if (_search.isNotEmpty) {
      filtered = filtered.where((c) => c.name.toLowerCase().contains(_search.toLowerCase()) || (c.companyName?.toLowerCase().contains(_search.toLowerCase()) ?? false)).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(
                hintText: 'Rechercher un contact...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Filters
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(label: const Text('Tous'), selected: _filterType == null, onSelected: (_) => setState(() => _filterType = null)),
                ),
                ...ContactType.values.where((t) => t != ContactType.tenant).map((type) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(_typeLabel(type)),
                    selected: _filterType == type,
                    onSelected: (_) => setState(() => _filterType = _filterType == type ? null : type),
                  ),
                )),
              ],
            ),
          ),

          // Contacts List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final c = filtered[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primarySurface,
                      child: Text(c.name[0], style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                    ),
                    title: Text(c.name, style: AppTextStyles.labelLarge),
                    subtitle: Text('${c.companyName ?? ''} • ${_typeLabel(c.contactType)}', style: AppTextStyles.caption),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (c.phoneNumber != null)
                          IconButton(icon: const Icon(Icons.phone, size: 20), color: AppColors.secondary, onPressed: () {}),
                        if (c.email != null)
                          IconButton(icon: const Icon(Icons.email, size: 20), color: AppColors.primary, onPressed: () {}),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      ),
    );
  }
}
