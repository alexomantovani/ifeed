// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalPostModelAdapter extends TypeAdapter<LocalPostModel> {
  @override
  final int typeId = 2;

  @override
  LocalPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalPostModel(
      userId: fields[0] as double,
      id: fields[1] as double,
      title: fields[2] as String,
      body: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalPostModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
