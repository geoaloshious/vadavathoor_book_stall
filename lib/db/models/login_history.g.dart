// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginHistoryModelAdapter extends TypeAdapter<LoginHistoryModel> {
  @override
  final int typeId = 13;

  @override
  LoginHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginHistoryModel(
      id: fields[0] as String,
      userID: fields[1] as String,
      logInTime: fields[2] as int,
      logOutTime: fields[3] as int,
      synced: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LoginHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.logInTime)
      ..writeByte(3)
      ..write(obj.logOutTime)
      ..writeByte(4)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
