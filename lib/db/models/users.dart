import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'users.g.dart';

UserModel emptyUserModel() => UserModel(
      userID: '',
      name: '',
      username: '',
      password: '',
      role: 0,
      batchID: '',
      emailID: '',
      notes: '',
      createdDate: 0,
      createdBy: '',
      modifiedDate: 0,
      modifiedBy: '',
      status: 0,
    );

@HiveType(typeId: DBItemHiveType.users)
class UserModel {
  @HiveField(0)
  final String userID;

  @HiveField(1)
  String name;

  @HiveField(3)
  String username;

  @HiveField(4)
  String password;

  @HiveField(5)
  int role;

  @HiveField(6)
  String batchID;

  @HiveField(7)
  String emailID;

  @HiveField(8)
  String notes;

  @HiveField(9)
  int createdDate;

  @HiveField(10)
  String createdBy;

  @HiveField(11)
  int modifiedDate;

  @HiveField(12)
  String modifiedBy;

  @HiveField(13)
  int status;

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
      required this.emailID,
      required this.notes,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy,
      required this.status});
}
