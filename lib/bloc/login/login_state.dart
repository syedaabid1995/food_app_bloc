import 'package:equatable/equatable.dart';

import '../../model/login/login_response.dart';


abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  const LoginLoading();

  @override
  List<Object> get props => [];
}

class LoginLoaded extends LoginState {
  final LoginResponse? response;

  const LoginLoaded(this.response);

  @override
  List<Object> get props => [this.response!];
}

class LoginError extends LoginState {
  final String error;

  const LoginError(this.error);

  @override
  List<Object> get props => [this.error];
}
