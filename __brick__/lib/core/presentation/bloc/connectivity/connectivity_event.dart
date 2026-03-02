import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  const ConnectivityChanged(this.isConnected);
  final bool isConnected;

  @override
  List<Object> get props => [isConnected];
}
