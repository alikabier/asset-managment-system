import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'Asset.dart';

class AssetRepository {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Asset>> getAssets() async {
    final assetList = _prefs.getStringList('assets') ?? [];
    return assetList.map((item) => Asset.fromJson(jsonDecode(item))).toList();
  }

  Future<void> saveAssets(List<Asset> assets) async {
    final assetList = assets.map((asset) => jsonEncode(asset.toJson())).toList();
    await _prefs.setStringList('assets', assetList);
  }
}
