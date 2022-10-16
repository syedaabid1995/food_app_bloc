import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../model/login/login_model.dart';
import '../../model/login/login_response.dart';
import '../../repository/user_repository.dart';
import '../../utils/save_to_hive.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepo userRepo;
  Box? _userBox;

  LoginBloc(this.userRepo) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is ProcessInitial) {
        emit(LoginInitial());
      }

      if (event is ProcessLogin) {
        emit(LoginInitial());
        _userBox = event.userBox;
        LoginModel loginModel = event.loginModel;
        bool hasError = false;

        if (!hasError) {
          emit(LoginLoading());
          LoginResponse loginResponse = await userRepo.login(loginModel);
          if (loginResponse.isSuccess!) {
            HiveData(_userBox!).setLoginDetails(loginResponse);
            emit(LoginLoaded(loginResponse));
          } else {
            emit(LoginError(
                loginResponse.message ?? loginResponse.error.toString()));
          }
        }
      }
    });
  }
}