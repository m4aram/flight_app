import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/profile_usecases.dart';

// ---------------- Events ----------------

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}

final class ProfileSubmitted extends ProfileEvent {
  const ProfileSubmitted(this.profile);

  final Profile profile;

  @override
  List<Object?> get props => [profile];
}

// ---------------- State ----------------

enum ProfileStatus { initial, loading, loaded, saving, saved, failure }

final class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  final ProfileStatus status;
  final Profile? profile;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, profile, errorMessage];
}

// ---------------- Bloc ----------------

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetProfile getProfile,
    required SaveProfile saveProfile,
  }) : _getProfile = getProfile,
       _saveProfile = saveProfile,
       super(const ProfileState()) {
    on<ProfileRequested>(_onRequested);
    on<ProfileSubmitted>(_onSubmitted);
  }

  final GetProfile _getProfile;
  final SaveProfile _saveProfile;

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileState(status: ProfileStatus.loading, profile: state.profile));
    final result = await _getProfile(const NoParams());
    result.fold(
      (failure) => emit(
        ProfileState(
          status: ProfileStatus.failure,
          profile: state.profile,
          errorMessage: failure.message,
        ),
      ),
      (profile) =>
          emit(ProfileState(status: ProfileStatus.loaded, profile: profile)),
    );
  }

  Future<void> _onSubmitted(
    ProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.status == ProfileStatus.saving) return;

    emit(ProfileState(status: ProfileStatus.saving, profile: state.profile));
    final result = await _saveProfile(event.profile);
    result.fold(
      (failure) => emit(
        ProfileState(
          status: ProfileStatus.failure,
          profile: state.profile,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        ProfileState(status: ProfileStatus.saved, profile: event.profile),
      ),
    );
  }
}
