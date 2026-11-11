import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/travel_document.dart';
import '../../domain/usecases/travel_document_usecases.dart';

// ---------------- Events ----------------

sealed class TravelDocumentEvent extends Equatable {
  const TravelDocumentEvent();

  @override
  List<Object?> get props => [];
}

final class TravelDocumentRequested extends TravelDocumentEvent {
  const TravelDocumentRequested();
}

final class TravelDocumentSubmitted extends TravelDocumentEvent {
  const TravelDocumentSubmitted(this.document);

  final TravelDocument document;

  @override
  List<Object?> get props => [document];
}

// ---------------- State ----------------

enum TravelDocumentStatus { initial, loading, loaded, saving, saved, failure }

final class TravelDocumentState extends Equatable {
  const TravelDocumentState({
    this.status = TravelDocumentStatus.initial,
    this.document,
    this.errorMessage,
  });

  final TravelDocumentStatus status;
  final TravelDocument? document;
  final String? errorMessage;

  bool get hasValidDocument => document != null && !document!.isExpired;

  @override
  List<Object?> get props => [status, document, errorMessage];
}

// ---------------- Bloc ----------------

class TravelDocumentBloc
    extends Bloc<TravelDocumentEvent, TravelDocumentState> {
  TravelDocumentBloc({
    required GetTravelDocument getDocument,
    required SaveTravelDocument saveDocument,
  }) : _getDocument = getDocument,
       _saveDocument = saveDocument,
       super(const TravelDocumentState()) {
    on<TravelDocumentRequested>(_onRequested);
    on<TravelDocumentSubmitted>(_onSubmitted);
  }

  final GetTravelDocument _getDocument;
  final SaveTravelDocument _saveDocument;

  Future<void> _onRequested(
    TravelDocumentRequested event,
    Emitter<TravelDocumentState> emit,
  ) async {
    emit(
      TravelDocumentState(
        status: TravelDocumentStatus.loading,
        document: state.document,
      ),
    );
    final result = await _getDocument(const NoParams());
    result.fold(
      (failure) => emit(
        TravelDocumentState(
          status: TravelDocumentStatus.failure,
          document: state.document,
          errorMessage: failure.message,
        ),
      ),
      (document) => emit(
        TravelDocumentState(
          status: TravelDocumentStatus.loaded,
          document: document,
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    TravelDocumentSubmitted event,
    Emitter<TravelDocumentState> emit,
  ) async {
    if (state.status == TravelDocumentStatus.saving) return;

    emit(
      TravelDocumentState(
        status: TravelDocumentStatus.saving,
        document: state.document,
      ),
    );
    final result = await _saveDocument(event.document);
    result.fold(
      (failure) => emit(
        TravelDocumentState(
          status: TravelDocumentStatus.failure,
          document: state.document,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        TravelDocumentState(
          status: TravelDocumentStatus.saved,
          document: event.document,
        ),
      ),
    );
  }
}
