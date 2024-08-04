// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MiscModelAdapter extends TypeAdapter<MiscModel> {
  @override
  final int typeId = 7;

  @override
  MiscModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MiscModel(
      itemKey: fields[0] as String,
      itemValue: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MiscModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.itemKey)
      ..writeByte(1)
      ..write(obj.itemValue);
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
