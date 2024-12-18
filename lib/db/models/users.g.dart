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
      userID: fields[0] as String,
      name: fields[1] as String,
      username: fields[3] as String,
      password: fields[4] as String,
      role: fields[5] as int,
      batchID: fields[6] as String,
      emailID: fields[7] as String,
      notes: fields[8] as String,
      createdDate: fields[9] as int,
      createdBy: fields[10] as String,
      modifiedDate: fields[11] as int,
      modifiedBy: fields[12] as String,
      status: fields[13] as int,
      synced: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.emailID)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.createdDate)
      ..writeByte(10)
      ..write(obj.createdBy)
      ..writeByte(11)
      ..write(obj.modifiedDate)
      ..writeByte(12)
      ..write(obj.modifiedBy)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.synced);
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
