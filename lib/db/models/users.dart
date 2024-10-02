import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'users.g.dart';

UserModel emptyUserModel() => UserModel(
    userID: 0,
    name: '',
    username: '',
    password: '',
    role: 0,
    batchID: 0,
    status: 0,
    createdDate: 0,
    createdBy: 0,
    modifiedDate: 0,
    modifiedBy: 0);

@HiveType(typeId: DBItemHiveType.users)
class UserModel {
  @HiveField(0)
  final int userID;

  @HiveField(1)
  String name;

  @HiveField(3)
  String username;

  @HiveField(4)
  String password;

  @HiveField(5)
  int role;

  @HiveField(6)
  int batchID;

  @HiveField(7)
  int status;

  @HiveField(8)
  final int createdDate;

  @HiveField(9)
  final int createdBy;

  @HiveField(10)
  int modifiedDate;

  @HiveField(11)
  int modifiedBy;

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'name': name,
      'username': username,
      'password': password,
      'role': role,
      'batchID': batchID,
      'status': status,
      'createdDate': createdDate,
      'createdBy': createdBy,
      'modifiedDate': modifiedDate,
      'modifiedBy': modifiedBy,
    };
  }

  Map<String, String> toDropdownData() {
    return {'id': userID.toString(), 'name': name};
  }

  UserModel(
      {required this.userID,
      required this.name,
      required this.username,
      required this.password,
      required this.role,
      required this.batchID,
      required this.status,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy});
}
