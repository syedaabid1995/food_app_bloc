import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../model/login/login_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class ProcessLogin extends LoginEvent {
  final LoginModel loginModel;
  final Box userBox;

  const ProcessLogin(this.loginModel, this.userBox);

  @override
  List<Object> get props => [this.loginModel, this.userBox];
}

class ProcessInitial extends LoginEvent {
  const ProcessInitial();

  @override
  List<Object> get props => [];
}
