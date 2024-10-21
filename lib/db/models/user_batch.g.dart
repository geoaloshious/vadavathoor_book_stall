// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_batch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserBatchModelAdapter extends TypeAdapter<UserBatchModel> {
  @override
  final int typeId = 12;

  @override
  UserBatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBatchModel(
      batchID: fields[0] as String,
      batchName: fields[1] as String,
      status: fields[2] as int,
      createdDate: fields[3] as int,
      createdBy: fields[4] as String,
      modifiedDate: fields[5] as int,
      modifiedBy: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserBatchModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.batchID)
      ..writeByte(1)
      ..write(obj.batchName)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.createdDate)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.modifiedDate)
      ..writeByte(6)
      ..write(obj.modifiedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
