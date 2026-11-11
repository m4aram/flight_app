import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/usecases/get_home_content.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getHomeContent) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
  }

  final GetHomeContent _getHomeContent;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await _getHomeContent(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (content) =>
          emit(state.copyWith(status: HomeStatus.loaded, content: content)),
    );
  }
}
