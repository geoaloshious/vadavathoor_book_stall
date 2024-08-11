// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_attachment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseAttachmentModelAdapter
    extends TypeAdapter<PurchaseAttachmentModel> {
  @override
  final int typeId = 7;

  @override
  PurchaseAttachmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseAttachmentModel(
      id: fields[0] as int?,
      purchaseID: fields[1] as String,
      fileName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseAttachmentModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.purchaseID)
      ..writeByte(2)
      ..write(obj.fileName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseAttachmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
