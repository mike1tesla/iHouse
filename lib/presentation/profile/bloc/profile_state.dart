part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity userEntity;

  ProfileLoaded({required this.userEntity});
}

class ProfileFailure extends ProfileState {}


