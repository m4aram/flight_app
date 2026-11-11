import '../../../../core/utils/result.dart';
import '../entities/travel_document.dart';

abstract interface class TravelDocumentRepository {
  /// `null` when no document was saved yet.
  Future<Result<TravelDocument?>> getDocument();

  Future<Result<void>> saveDocument(TravelDocument document);
}
