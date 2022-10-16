import 'package:food_app/model/login/user_details.dart';
import 'package:hive/hive.dart';
part 'login_response.g.dart';

@HiveType(typeId: 1)
class LoginResponse {

  @HiveField(0)
  int? status;

  @HiveField(1)
  bool? isSuccess=false;

  @HiveField(2)
  String? message;

  @HiveField(3)
  String? error;

  @HiveField(4)
  UserDetails? userDetails;

  @HiveField(5)
  String? token;


  LoginResponse({this.status, this.isSuccess, this.message,this.userDetails,this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    token = json['token'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;

  }
  LoginResponse.withError(String error) {
    this.error = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['Token'] = this.token;
    if (this.userDetails != null) {
      data['UserDetails'] = this.userDetails!.toJson();
    }

    return data;
  }
}