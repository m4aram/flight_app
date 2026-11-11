import '../../../../core/utils/result.dart';
import '../../domain/entities/travel_document.dart';
import '../../domain/repositories/travel_document_repository.dart';
import '../datasources/travel_document_local_data_source.dart';

class TravelDocumentRepositoryImpl implements TravelDocumentRepository {
  const TravelDocumentRepositoryImpl(this._local);

  final TravelDocumentLocalDataSource _local;

  @override
  Future<Result<TravelDocument?>> getDocument() => guard(_local.getDocument);

  @override
  Future<Result<void>> saveDocument(TravelDocument document) =>
      guard(() => _local.saveDocument(document));
}
