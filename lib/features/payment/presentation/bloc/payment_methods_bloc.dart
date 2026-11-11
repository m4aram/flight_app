import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/payment_usecases.dart';

// ---------------- Events ----------------

sealed class PaymentMethodsEvent extends Equatable {
  const PaymentMethodsEvent();

  @override
  List<Object?> get props => [];
}

final class PaymentMethodsStarted extends PaymentMethodsEvent {
  const PaymentMethodsStarted();
}

final class PaymentSearchChanged extends PaymentMethodsEvent {
  const PaymentSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class PaymentMethodSelected extends PaymentMethodsEvent {
  const PaymentMethodSelected(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class PaymentViewAllPressed extends PaymentMethodsEvent {
  const PaymentViewAllPressed();
}

final class PaymentPreferenceSaved extends PaymentMethodsEvent {
  const PaymentPreferenceSaved();
}

// ---------------- State ----------------

enum PaymentLoadStatus { loading, loaded, failure }

enum PaymentSaveStatus { idle, saving, saved, failure }

final class PaymentMethodsState extends Equatable {
  const PaymentMethodsState({
    this.methods = const [],
    this.query = '',
    this.selectedId,
    this.showAll = false,
    this.loadStatus = PaymentLoadStatus.loading,
    this.saveStatus = PaymentSaveStatus.idle,
    this.errorMessage,
  });

  /// Methods shown before pressing "VIEW ALL".
  static const int collapsedCount = 4;

  final List<PaymentMethod> methods;
  final String query;
  final String? selectedId;
  final bool showAll;
  final PaymentLoadStatus loadStatus;
  final PaymentSaveStatus saveStatus;
  final String? errorMessage;

  List<PaymentMethod> get visibleMethods {
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      return methods.where((m) => m.name.toLowerCase().contains(q)).toList();
    }
    return showAll ? methods : methods.take(collapsedCount).toList();
  }

  bool get canViewAll =>
      !showAll && query.trim().isEmpty && methods.length > collapsedCount;

  PaymentMethod? get selectedMethod {
    for (final m in methods) {
      if (m.id == selectedId) return m;
    }
    return null;
  }

  PaymentMethodsState copyWith({
    List<PaymentMethod>? methods,
    String? query,
    String? selectedId,
    bool? showAll,
    PaymentLoadStatus? loadStatus,
    PaymentSaveStatus? saveStatus,
    String? errorMessage,
  }) {
    return PaymentMethodsState(
      methods: methods ?? this.methods,
      query: query ?? this.query,
      selectedId: selectedId ?? this.selectedId,
      showAll: showAll ?? this.showAll,
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? PaymentSaveStatus.idle,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    methods,
    query,
    selectedId,
    showAll,
    loadStatus,
    saveStatus,
    errorMessage,
  ];
}

// ---------------- Bloc ----------------

class PaymentMethodsBloc
    extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  PaymentMethodsBloc({
    required GetPaymentMethods getPaymentMethods,
    required GetPreferredPaymentMethod getPreferred,
    required SavePreferredPaymentMethod savePreferred,
  }) : _getPaymentMethods = getPaymentMethods,
       _getPreferred = getPreferred,
       _savePreferred = savePreferred,
       super(const PaymentMethodsState()) {
    on<PaymentMethodsStarted>(_onStarted);
    on<PaymentSearchChanged>(
      (event, emit) => emit(state.copyWith(query: event.query)),
    );
    on<PaymentMethodSelected>(
      (event, emit) => emit(state.copyWith(selectedId: event.id)),
    );
    on<PaymentViewAllPressed>(
      (event, emit) => emit(state.copyWith(showAll: true)),
    );
    on<PaymentPreferenceSaved>(_onSaved);
  }

  final GetPaymentMethods _getPaymentMethods;
  final GetPreferredPaymentMethod _getPreferred;
  final SavePreferredPaymentMethod _savePreferred;

  Future<void> _onStarted(
    PaymentMethodsStarted event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    emit(state.copyWith(loadStatus: PaymentLoadStatus.loading));

    final methodsResult = await _getPaymentMethods(const NoParams());
    final preferredResult = await _getPreferred(const NoParams());
    final preferredId = preferredResult.fold((_) => null, (id) => id);

    methodsResult.fold(
      (failure) => emit(
        state.copyWith(
          loadStatus: PaymentLoadStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (methods) {
        final isKnown = methods.any((m) => m.id == preferredId);
        emit(
          state.copyWith(
            methods: methods,
            selectedId: isKnown ? preferredId : null,
            // Make sure a saved method outside the first 4 is visible.
            showAll:
                isKnown &&
                methods.indexWhere((m) => m.id == preferredId) >=
                    PaymentMethodsState.collapsedCount,
            loadStatus: PaymentLoadStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onSaved(
    PaymentPreferenceSaved event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    // Reset to idle first so a repeated error is shown again.
    emit(state.copyWith(saveStatus: PaymentSaveStatus.idle));

    final id = state.selectedId;
    if (id == null) {
      emit(
        state.copyWith(
          saveStatus: PaymentSaveStatus.failure,
          errorMessage: 'Please select a payment type',
        ),
      );
      return;
    }

    emit(state.copyWith(saveStatus: PaymentSaveStatus.saving));
    final result = await _savePreferred(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          saveStatus: PaymentSaveStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(saveStatus: PaymentSaveStatus.saved)),
    );
  }
}
