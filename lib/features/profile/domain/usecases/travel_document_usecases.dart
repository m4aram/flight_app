import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/travel_document.dart';
import '../repositories/travel_document_repository.dart';

class GetTravelDocument implements UseCase<TravelDocument?, NoParams> {
  const GetTravelDocument(this._repository);

  final TravelDocumentRepository _repository;

  @override
  Future<Result<TravelDocument?>> call(NoParams params) =>
      _repository.getDocument();
}

class SaveTravelDocument implements UseCase<void, TravelDocument> {
  const SaveTravelDocument(this._repository);

  final TravelDocumentRepository _repository;

  @override
  Future<Result<void>> call(TravelDocument params) async {
    final numberError = Validators.documentNumber(params.number);
    if (numberError != null) return Failed(ValidationFailure(numberError));

    if (params.issuingCountry.trim().isEmpty) {
      return const Failed(
        ValidationFailure('Please choose the issuing country'),
      );
    }

    if (!params.expiryDate.isAfter(DateFormatter.today())) {
      return const Failed(ValidationFailure('This document has expired'));
    }

    return _repository.saveDocument(
      TravelDocument(
        type: params.type,
        number: params.number.trim().toUpperCase(),
        issuingCountry: params.issuingCountry,
        expiryDate: DateFormatter.dateOnly(params.expiryDate),
      ),
    );
  }
}
