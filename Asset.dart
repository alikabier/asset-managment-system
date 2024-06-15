import 'package:flutter/material.dart';
class Asset {
  String assetId;
  String assetName;
  String assetType;
  String purchaseDate;
  String value;
  String location;
  List<String> associatedItems;

  Asset({
    required this.assetId,
    required this.assetName,
    required this.assetType,
    required this.purchaseDate,
    required this.value,
    required this.location,
    required this.associatedItems,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetId: json['asset_id'],
      assetName: json['asset_name'],
      assetType: json['asset_type'],
      purchaseDate: json['purchase_date'],
      value: json['value'],
      location: json['location'],
      associatedItems: List<String>.from(json['associated_items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_id': assetId,
      'asset_name': assetName,
      'asset_type': assetType,
      'purchase_date': purchaseDate,
      'value': value,
      'location': location,
      'associated_items': associatedItems,
    };
  }
}
