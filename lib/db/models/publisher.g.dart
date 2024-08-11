// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PublisherModelAdapter extends TypeAdapter<PublisherModel> {
  @override
  final int typeId = 6;

  @override
  PublisherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PublisherModel(
      publisherID: fields[0] as String,
      publisherName: fields[1] as String,
      publisherAddress: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PublisherModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.publisherID)
      ..writeByte(1)
      ..write(obj.publisherName)
      ..writeByte(2)
      ..write(obj.publisherAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublisherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
