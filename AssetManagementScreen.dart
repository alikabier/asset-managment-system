import 'package:flutter/material.dart';

import 'Asset.dart';
import 'AssetForm.dart';
import 'AssetRepository.dart';

class AssetManagementScreen extends StatefulWidget {
  @override
  _AssetManagementScreenState createState() => _AssetManagementScreenState();
}

class _AssetManagementScreenState extends State<AssetManagementScreen> {
  final AssetRepository _repository = AssetRepository();
  final AssetForm _form = AssetForm();
  List<Asset> _assets = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _repository.init();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    final assets = await _repository.getAssets();
    setState(() {
      _assets = assets;
    });
  }

  Future<void> _saveAssets() async {
    await _repository.saveAssets(_assets);
  }

  Future<void> _addAsset() async {
    if (_form.assetIdController.text.isEmpty || _form.assetNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Asset ID and Asset Name are required'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final asset = _form.getAssetFromForm();
    setState(() {
      _assets.add(asset);
      _form.clearForm();
      _selectedIndex = null;
    });
    await _saveAssets();
  }

  Future<void> _updateAsset() async {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an asset to update'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final asset = _form.getAssetFromForm();
    setState(() {
      _assets[_selectedIndex!] = asset;
      _form.clearForm();
      _selectedIndex = null;
    });
    await _saveAssets();
  }

  Future<void> _deleteAsset(int index) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this asset?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _assets.removeAt(index);
      });
      await _saveAssets();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Asset deleted successfully'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  void _editAsset(int index, Asset asset) {
    setState(() {
      _selectedIndex = index;
      _form.fillFormFromAsset(asset);
    });
  }

  void _clearForm() {
    _form.clearForm();
    setState(() {
      _selectedIndex = null;
    });
  }

  void _showAssetInfoDialog(BuildContext context, Asset asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Asset Information'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asset ID: ${asset.assetId}'),
              SizedBox(height: 10),
              Text('Asset Name: ${asset.assetName}'),
              SizedBox(height: 10),
              Text('Asset Type: ${asset.assetType}'),
              SizedBox(height: 10),
              Text('Purchase Date: ${asset.purchaseDate}'),
              SizedBox(height: 10),
              Text('Value: ${asset.value}'),
              SizedBox(height: 10),
              Text('Location: ${asset.location}'),
              SizedBox(height: 10),
              Text('Associated Items:'),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: asset.associatedItems
                    .map((item) => Chip(label: Text(item)))
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Management'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asset ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _form.assetIdController),
            SizedBox(height: 10.0),
            Text('Asset Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _form.assetNameController),
            SizedBox(height: 10.0),
            Text('Asset Type:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _form.assetTypeController),
            SizedBox(height: 10.0),
            Text('Purchase Date:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _form.purchaseDateController),
            SizedBox(height: 10.0),
            Text('Value:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _form.valueController),
            SizedBox(height: 10.0),
            Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _form.locationController),
            SizedBox(height: 10.0),
            Text('Associated Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _form.associatedItems
                  .map((item) => Chip(
                label: Text(item),
                onDeleted: () {
                  setState(() {
                    _form.associatedItems.remove(item);
                  });
                },
              ))
                  .toList(),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String newItem = '';
                    return AlertDialog(
                      title: Text('Add Associated Item'),
                      content: TextField(
                        onChanged: (value) {
                          newItem = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter item name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _form.associatedItems.add(newItem);
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Item'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectedIndex != null ? _updateAsset : _addAsset,
                  child: Text(_selectedIndex != null ? 'Update Asset' : 'Add Asset'),
                ),
                ElevatedButton(
                  onPressed: _clearForm,
                  child: Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _assets.length,
              itemBuilder: (context, index) {
                final asset = _assets[index];
                return ListTile(
                  title: Text('Asset ID: ${asset.assetId}'),
                  subtitle: Text('Asset Name: ${asset.assetName}'),
                  onTap: () => _showAssetInfoDialog(context, asset),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editAsset(index, asset),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteAsset(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
