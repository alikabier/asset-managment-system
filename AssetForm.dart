import 'package:flutter/material.dart';

import 'Asset.dart';

class AssetForm {
  final TextEditingController assetIdController = TextEditingController();
  final TextEditingController assetNameController = TextEditingController();
  final TextEditingController assetTypeController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  List<String> associatedItems = [];

  Asset getAssetFromForm() {
    return Asset(
      assetId: assetIdController.text,
      assetName: assetNameController.text,
      assetType: assetTypeController.text,
      purchaseDate: purchaseDateController.text,
      value: valueController.text,
      location: locationController.text,
      associatedItems: associatedItems,
    );
  }

  void fillFormFromAsset(Asset asset) {
    assetIdController.text = asset.assetId;
    assetNameController.text = asset.assetName;
    assetTypeController.text = asset.assetType;
    purchaseDateController.text = asset.purchaseDate;
    valueController.text = asset.value;
    locationController.text = asset.location;
    associatedItems = asset.associatedItems;
  }

  void clearForm() {
    assetIdController.clear();
    assetNameController.clear();
    assetTypeController.clear();
    purchaseDateController.clear();
    valueController.clear();
    locationController.clear();
    associatedItems.clear();
  }
}
