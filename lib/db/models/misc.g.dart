// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MiscModelAdapter extends TypeAdapter<MiscModel> {
  @override
  final int typeId = 10;

  @override
  MiscModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MiscModel(
      itemKey: fields[0] as String,
      itemValue: fields[1] as String,
      createdDate: fields[2] as int,
      createdBy: fields[3] as String,
      modifiedDate: fields[4] as int,
      modifiedBy: fields[5] as String,
      synced: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MiscModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.itemKey)
      ..writeByte(1)
      ..write(obj.itemValue)
      ..writeByte(2)
      ..write(obj.createdDate)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.modifiedDate)
      ..writeByte(5)
      ..write(obj.modifiedBy)
      ..writeByte(6)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiscModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
