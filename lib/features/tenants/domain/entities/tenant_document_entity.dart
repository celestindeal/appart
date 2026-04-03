import 'package:equatable/equatable.dart';

/// Type de document du locataire.
enum TenantDocumentType {
  bail('Bail'),
  pieceIdentite("Piece d'identite"),
  justificatifRevenu('Justificatif de revenu'),
  etatDesLieux('Etat des lieux'),
  quittance('Quittance de loyer'),
  autre('Autre');

  const TenantDocumentType(this.label);
  final String label;
}

/// Entite representant un document associe a un locataire.
class TenantDocumentEntity extends Equatable {
  const TenantDocumentEntity({
    required this.id,
    required this.tenantId,
    required this.documentType,
    required this.fileName,
    required this.fileUrl,
    required this.uploadedDate,
  });

  final String id;
  final String tenantId;
  final TenantDocumentType documentType;
  final String fileName;
  final String fileUrl;
  final DateTime uploadedDate;

  TenantDocumentEntity copyWith({
    String? id,
    String? tenantId,
    TenantDocumentType? documentType,
    String? fileName,
    String? fileUrl,
    DateTime? uploadedDate,
  }) {
    return TenantDocumentEntity(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      documentType: documentType ?? this.documentType,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      uploadedDate: uploadedDate ?? this.uploadedDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tenantId,
        documentType,
        fileName,
        fileUrl,
        uploadedDate,
      ];
}
