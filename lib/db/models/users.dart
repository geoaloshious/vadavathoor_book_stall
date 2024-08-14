import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/utils.dart';
part 'users.g.dart';

UserModel emptyUserModel() => UserModel(
    userID: '',
    firstName: '',
    lastName: '',
    username: '',
    password: '',
    role: 0,
    status: 0,
    lastLoginDate: 0,
    createdDate: 0,
    createdBy: '',
    modifiedDate: 0,
    modifiedBy: '');

class UserRole {
  static const int admin = 1;
  static const int normal = 2;
}

class UserStatus {
  static const int enabled = 1;
  static const int disabled = 2;
}

@HiveType(typeId: ItemType.users)
class UserModel {
  @HiveField(0)
  final String userID;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String username;

  @HiveField(4)
  final String password;

  @HiveField(5)
  final int role;

  @HiveField(6)
  final int status;

  @HiveField(7)
  final int lastLoginDate;

  @HiveField(8)
  final int createdDate;

  @HiveField(9)
  final String createdBy;

  @HiveField(10)
  final int modifiedDate;

  @HiveField(11)
  final String modifiedBy;

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'role': role,
      'status': status,
      'lastLoginDate': lastLoginDate,
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
      required this.status,
      required this.lastLoginDate,
      required this.createdDate,
      required this.createdBy,
      required this.modifiedDate,
      required this.modifiedBy});
}
