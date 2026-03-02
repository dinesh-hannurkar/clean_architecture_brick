import 'package:equatable/equatable.dart';

/// Base state for connectivity monitoring.
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

/// The initial state before the first connectivity check.
class ConnectivityInitial extends ConnectivityState {}

/// Represents the current connectivity status.
class ConnectivityStatus extends ConnectivityState {
  /// Creates a [ConnectivityStatus].
  ///
  /// [isConnected] is `true` when the device has an active internet connection.
  const ConnectivityStatus(this.isConnected);

  /// Whether the device currently has an internet connection.
  final bool isConnected;

  @override
  List<Object> get props => [isConnected];
}
