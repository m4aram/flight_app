import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/travel_document.dart';

/// Travel documents are personal data, so they live in encrypted storage.
abstract interface class TravelDocumentLocalDataSource {
  Future<TravelDocument?> getDocument();

  Future<void> saveDocument(TravelDocument document);
}

class TravelDocumentLocalDataSourceImpl
    implements TravelDocumentLocalDataSource {
  const TravelDocumentLocalDataSourceImpl(this._storage);

  final SecureStorage _storage;

  @override
  Future<TravelDocument?> getDocument() async {
    final raw = await _storage.read(StorageKeys.travelDocument);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;
      final typeName = json['type'] as String;
      return TravelDocument(
        type: DocumentType.values.firstWhere(
          (t) => t.name == typeName,
          orElse: () => DocumentType.passport,
        ),
        number: json['number'] as String,
        issuingCountry: json['issuing_country'] as String,
        expiryDate: DateTime.parse(json['expiry_date'] as String),
      );
    } catch (_) {
      throw const CacheException('Saved document data is corrupted');
    }
  }

  @override
  Future<void> saveDocument(TravelDocument document) async {
    try {
      await _storage.write(
        StorageKeys.travelDocument,
        jsonEncode({
          'type': document.type.name,
          'number': document.number,
          'issuing_country': document.issuingCountry,
          'expiry_date': document.expiryDate.toIso8601String(),
        }),
      );
    } catch (_) {
      throw const CacheException('Could not save your document');
    }
  }
}
