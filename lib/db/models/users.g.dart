// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 11;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userID: fields[0] as int,
      name: fields[1] as String,
      username: fields[3] as String,
      password: fields[4] as String,
      role: fields[5] as int,
      batchID: fields[6] as int,
      status: fields[7] as int,
      createdDate: fields[8] as int,
      createdBy: fields[9] as int,
      modifiedDate: fields[10] as int,
      modifiedBy: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.batchID)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.createdDate)
      ..writeByte(9)
      ..write(obj.createdBy)
      ..writeByte(10)
      ..write(obj.modifiedDate)
      ..writeByte(11)
      ..write(obj.modifiedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
