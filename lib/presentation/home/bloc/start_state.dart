import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';
import 'package:smart_iot/domain/repository/lockdoor/lockdoor.dart';

abstract class StartState {}

class StartInitial extends StartState {}

class StartLoading extends StartState {}

class StartLoaded extends StartState {}

class StartError extends StartState {
  final String message;

  StartError(this.message);
}
