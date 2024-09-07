import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
part 'users.g.dart';

UserModel emptyUserModel() => UserModel(
    userID: '',
    firstName: '',
    lastName: '',
    username: '',
    password: '',
    role: 0,
    batchID: '',
    status: 0,
    createdDate: 0,
    createdBy: '',
    modifiedDate: 0,
    modifiedBy: '');

@HiveType(typeId: DBItemHiveType.users)
class UserModel {
  @HiveField(0)
  final String userID;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String username;

  @HiveField(4)
  String password;

  @HiveField(5)
  int role;

  @HiveField(6)
  String batchID;

  @HiveField(7)
  int status;

  @HiveField(8)
  final int createdDate;

  @HiveField(9)
  final String createdBy;

  @HiveField(10)
  int modifiedDate;

  @HiveField(11)
  String modifiedBy;

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
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
    return {'id': userID, 'name': '$firstName $lastName'};
  }

  UserModel(
      {required this.userID,
      required this.firstName,
      required this.lastName,
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
