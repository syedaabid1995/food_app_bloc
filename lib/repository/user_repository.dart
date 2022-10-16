

import '../model/login/login_model.dart';
import '../model/login/login_response.dart';
import '../model/login/user_details.dart';

abstract class UserRepo {
  Future<LoginResponse> login(LoginModel loginModel);

}

class RealUserRepo extends UserRepo {

  @override
  Future<LoginResponse> login(LoginModel loginModel) {
    return Future<LoginResponse>(() {
      var emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      var passwordRegex = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$");
      var login = new LoginResponse();

      if(loginModel.email!.isEmpty || loginModel.password!.isEmpty){
        login.isSuccess = false;
        login.message = "All fields are mandatory";
        login.status = 0;
        return login;
      }

      if(emailRegex.hasMatch(loginModel.email!) && passwordRegex.hasMatch(loginModel.password!)){
        login.isSuccess = true;
        login.message = "Welcome ${loginModel.email!.split("@")[0]}";
        login.userDetails = UserDetails();
        login.userDetails!.userName = loginModel.email!.split("@")[0];
        login.userDetails!.userId = 1;
        login.status = 200;
      }else{
        login.isSuccess = false;
        login.message = "Login Failed";
        login.status = 201;
      }

      return login;
    });
  }
}

class FakeUserRepo extends UserRepo {
  @override
  Future<LoginResponse> login(LoginModel loginModel) {
    return Future<LoginResponse>(() {
      var login = new LoginResponse();
      login.isSuccess = true;
      login.message = "welcome user";
      login.status = 201;
      return login;
    });
  }

}
