import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/settings_usecases.dart';

// ---------------- Events ----------------

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

final class SettingsChanged extends SettingsEvent {
  const SettingsChanged(this.settings);

  final AppSettings settings;

  @override
  List<Object?> get props => [settings];
}

// ---------------- State ----------------

final class SettingsState extends Equatable {
  const SettingsState({this.settings = const AppSettings(), this.errorMessage});

  final AppSettings settings;
  final String? errorMessage;

  @override
  List<Object?> get props => [settings, errorMessage];
}

// ---------------- Bloc ----------------

/// App-wide settings (language, currency, region).
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetSettings getSettings,
    required SaveSettings saveSettings,
  }) : _getSettings = getSettings,
       _saveSettings = saveSettings,
       super(const SettingsState()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsChanged>(_onChanged);
  }

  final GetSettings _getSettings;
  final SaveSettings _saveSettings;

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await _getSettings(const NoParams());
    result.fold((_) {}, (settings) => emit(SettingsState(settings: settings)));
  }

  Future<void> _onChanged(
    SettingsChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final previous = state.settings;
    // Optimistic update, rolled back if saving fails.
    emit(SettingsState(settings: event.settings));
    final result = await _saveSettings(event.settings);
    result.fold(
      (failure) => emit(
        SettingsState(settings: previous, errorMessage: failure.message),
      ),
      (_) {},
    );
  }
}
