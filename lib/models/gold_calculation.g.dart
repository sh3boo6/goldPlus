// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gold_calculation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoldCalculationAdapter extends TypeAdapter<GoldCalculation> {
  @override
  final int typeId = 0;

  @override
  GoldCalculation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoldCalculation(
      weight: fields[0] as double,
      karat: fields[1] as int,
      pricePerGram: fields[2] as double,
      merchantPrice: fields[3] as double,
      rawGoldValue: fields[4] as double,
      makingFee: fields[5] as double,
      vat: fields[6] as double,
      totalFairPrice: fields[7] as double,
      priceDifference: fields[8] as double,
      date: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GoldCalculation obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.karat)
      ..writeByte(2)
      ..write(obj.pricePerGram)
      ..writeByte(3)
      ..write(obj.merchantPrice)
      ..writeByte(4)
      ..write(obj.rawGoldValue)
      ..writeByte(5)
      ..write(obj.makingFee)
      ..writeByte(6)
      ..write(obj.vat)
      ..writeByte(7)
      ..write(obj.totalFairPrice)
      ..writeByte(8)
      ..write(obj.priceDifference)
      ..writeByte(9)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoldCalculationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
