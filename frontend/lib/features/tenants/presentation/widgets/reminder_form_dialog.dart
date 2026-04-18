import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/reminder_entity.dart';
import '../providers/reminder_provider.dart';

/// Dialog d'ajout / edition d'un rappel.
class ReminderFormDialog extends ConsumerStatefulWidget {
  const ReminderFormDialog({
    super.key,
    required this.tenantId,
    this.reminder,
  });

  final String tenantId;
  final ReminderEntity? reminder;

  /// Helper pour afficher le dialog.
  static Future<bool?> show(
    BuildContext context, {
    required String tenantId,
    ReminderEntity? reminder,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => ReminderFormDialog(
        tenantId: tenantId,
        reminder: reminder,
      ),
    );
  }

  @override
  ConsumerState<ReminderFormDialog> createState() =>
      _ReminderFormDialogState();
}

class _ReminderFormDialogState extends ConsumerState<ReminderFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool get _isEditing => widget.reminder != null;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  ReminderType _type = ReminderType.custom;
  DateTime _date = DateTime.now();
  bool _isCompleted = false;
  bool _isSaving = false;

  static final _dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final r = widget.reminder!;
      _titleController.text = r.title;
      _descController.text = r.description;
      _type = r.reminderType;
      _date = r.reminderDate;
      _isCompleted = r.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final reminder = ReminderEntity(
        id: widget.reminder?.id ?? '',
        tenantId: widget.tenantId,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        reminderType: _type,
        reminderDate: _date,
        isCompleted: _isCompleted,
        createdAt: widget.reminder?.createdAt ?? DateTime.now(),
      );

      final actions = ref.read(reminderActionsProvider);
      if (_isEditing) {
        await actions.update(reminder);
      } else {
        await actions.create(reminder);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Rappel modifié avec succès'
                  : 'Rappel ajouté avec succès',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Modifier le rappel' : 'Nouveau rappel',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration('Titre'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ReminderType>(
                  value: _type,
                  decoration: _inputDecoration('Type'),
                  items: ReminderType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.label),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _type = v);
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: _inputDecoration('Date du rappel').copyWith(
                      suffixIcon: const Icon(Icons.calendar_today, size: 18),
                    ),
                    child: Text(
                      _dateFormat.format(_date),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration:
                      _inputDecoration('Description (optionnel)'),
                  maxLines: 3,
                ),
                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  SwitchListTile(
                    value: _isCompleted,
                    onChanged: (v) => setState(() => _isCompleted = v),
                    title: const Text('Terminé'),
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primary,
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(_isEditing ? 'Enregistrer' : 'Ajouter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
    );
  }
}
