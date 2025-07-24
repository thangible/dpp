// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NameplateAdapter extends TypeAdapter<Nameplate> {
  @override
  final int typeId = 0;

  @override
  Nameplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Nameplate(
      product: fields[0] as Product?,
      manufacturer: fields[1] as Manufacturer?,
    );
  }

  @override
  void write(BinaryWriter writer, Nameplate obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.manufacturer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      uriOfTheProduct: fields[0] as String?,
      manufacturerProductType: fields[1] as String?,
      orderCodeOfManufacturer: fields[2] as String?,
      productArticleNumberOfManufacturer: fields[3] as String?,
      serialNumber: fields[4] as String?,
      yearOfConstruction: fields[5] as int?,
      dateOfManufacture: fields[6] as DateTime?,
      countryOfOrigin: fields[7] as String?,
      manufacturerProductDesignation: fields[8] as String?,
      manufacturerProductRoot: fields[9] as String?,
      manufacturerProductFamily: fields[10] as String?,
      manufacturer: fields[11] as Manufacturer?,
      markings: fields[12] as Markings?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.uriOfTheProduct)
      ..writeByte(1)
      ..write(obj.manufacturerProductType)
      ..writeByte(2)
      ..write(obj.orderCodeOfManufacturer)
      ..writeByte(3)
      ..write(obj.productArticleNumberOfManufacturer)
      ..writeByte(4)
      ..write(obj.serialNumber)
      ..writeByte(5)
      ..write(obj.yearOfConstruction)
      ..writeByte(6)
      ..write(obj.dateOfManufacture)
      ..writeByte(7)
      ..write(obj.countryOfOrigin)
      ..writeByte(8)
      ..write(obj.manufacturerProductDesignation)
      ..writeByte(9)
      ..write(obj.manufacturerProductRoot)
      ..writeByte(10)
      ..write(obj.manufacturerProductFamily)
      ..writeByte(11)
      ..write(obj.manufacturer)
      ..writeByte(12)
      ..write(obj.markings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ManufacturerAdapter extends TypeAdapter<Manufacturer> {
  @override
  final int typeId = 2;

  @override
  Manufacturer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Manufacturer(
      uniqueFacilityIdentifier: fields[0] as String?,
      manufacturerName: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Manufacturer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uniqueFacilityIdentifier)
      ..writeByte(1)
      ..write(obj.manufacturerName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManufacturerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MarkingsAdapter extends TypeAdapter<Markings> {
  @override
  final int typeId = 3;

  @override
  Markings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Markings(
      markingName: fields[0] as String?,
      designationOfCertificateOrApproval: fields[1] as String?,
      issueDate: fields[2] as DateTime?,
      expiryDate: fields[3] as DateTime?,
      markingAdditionalText: fields[4] as String?,
      markingFile: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Markings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.markingName)
      ..writeByte(1)
      ..write(obj.designationOfCertificateOrApproval)
      ..writeByte(2)
      ..write(obj.issueDate)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.markingAdditionalText)
      ..writeByte(5)
      ..write(obj.markingFile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
