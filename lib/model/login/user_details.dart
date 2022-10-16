import 'package:hive/hive.dart';
part 'user_details.g.dart';

@HiveType(typeId: 2)
class UserDetails {

  @HiveField(0)
  int? userId;

  @HiveField(1)
  String? userName;

  @HiveField(2)
  String? error;

  UserDetails({this.userId,this.userName});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];

  }
  UserDetails.withError(String error) {
    this.error = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;

    return data;
  }
}