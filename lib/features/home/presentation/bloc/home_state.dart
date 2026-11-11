part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, failure }

final class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.content,
    this.errorMessage,
  });

  final HomeStatus status;
  final HomeContent? content;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    HomeContent? content,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      content: content ?? this.content,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, content, errorMessage];
}
