import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Prints every Event and State change of every Bloc in the app.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  /// Called when a Bloc receives an Event.
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('EVENT  | ${bloc.runtimeType} <- $event');
  }

  /// Called when a Bloc emits a new State.
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('STATE  | ${bloc.runtimeType} -> ${change.nextState}');
  }

  /// Called when something throws inside a Bloc.
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('ERROR  | ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }
}