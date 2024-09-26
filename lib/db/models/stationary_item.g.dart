// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stationary_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StationaryItemModelAdapter extends TypeAdapter<StationaryItemModel> {
  @override
  final int typeId = 14;

  @override
  StationaryItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StationaryItemModel(
      itemID: fields[0] as String,
      itemName: fields[1] as String,
      createdDate: fields[2] as int,
      createdBy: fields[3] as String,
      modifiedDate: fields[4] as int,
      modifiedBy: fields[5] as String,
      status: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StationaryItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.itemID)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.createdDate)
      ..writeByte(3)
      ..write(obj.createdBy)
      ..writeByte(4)
      ..write(obj.modifiedDate)
      ..writeByte(5)
      ..write(obj.modifiedBy)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StationaryItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
