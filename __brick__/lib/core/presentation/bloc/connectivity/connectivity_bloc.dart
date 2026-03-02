import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name}}/core/data/network/network_info.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({required NetworkInfo networkInfo})
    : _networkInfo = networkInfo,
      super(ConnectivityInitial()) {
    on<ConnectivityChanged>(_onConnectivityChanged);

    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen(
      (isConnected) => add(ConnectivityChanged(isConnected)),
    );

    // Check initial status
    _checkInitialStatus();
  }

  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? _connectivitySubscription;

  Future<void> _checkInitialStatus() async {
    final isConnected = await _networkInfo.isConnected;
    add(ConnectivityChanged(isConnected));
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(ConnectivityStatus(event.isConnected));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
