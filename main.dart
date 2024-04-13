import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Asset {
  String name;
  int quantity;

  Asset(this.name, this.quantity);
}

class Department {
  String name;
  List<Asset> assets;

  Department(this.name, this.assets);
}

class Faculty {
  String name;
  List<Department> departments;

  Faculty(this.name, this.departments);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Asset Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AssetManagementPage(),
    );
  }
}

class AssetManagementPage extends StatefulWidget {
  @override
  _AssetManagementPageState createState() => _AssetManagementPageState();
}

class _AssetManagementPageState extends State<AssetManagementPage> {
  List<Faculty> faculties = [
    Faculty(
      'Faculty of Science',
      [
        Department('Physics', []),
        Department('Chemistry', []),
      ],
    ),

  ];

  String selectedFaculty = 'Faculty of Science';
  String selectedDepartment = 'Physics';

  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  int getTotalAssets() {
    int total = 0;
    for (var faculty in faculties) {
      for (var department in faculty.departments) {
        total += department.assets.length;
      }
    }
    return total;
  }

  void addAsset(Asset asset) {
    faculties
        .firstWhere((f) => f.name == selectedFaculty)
        .departments
        .firstWhere((d) => d.name == selectedDepartment)
        .assets
        .add(asset);
  }

  void deleteAsset(Asset asset) {
    faculties
        .firstWhere((f) => f.name == selectedFaculty)
        .departments
        .firstWhere((d) => d.name == selectedDepartment)
        .assets
        .remove(asset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('University Asset Management'),
      ),
      body: ListView.builder(
        itemCount: faculties.length,
        itemBuilder: (BuildContext context, int facultyIndex) {
          final faculty = faculties[facultyIndex];
          return ExpansionTile(
            title: Text(faculty.name),
            children: faculty.departments.map((department) {
              return ExpansionTile(
                title: Text(department.name),
                children: department.assets.map((asset) {
                  return ListTile(
                    title: Text(asset.name),
                    subtitle: Text('Quantity: ${asset.quantity}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          deleteAsset(asset);
                        });
                      },
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Asset"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Asset Name'),
                    ),
                    TextField(
                      controller: quantityController,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButton<String>(
                      hint: Text('Select Faculty'),
                      value: selectedFaculty,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFaculty = newValue!;
                          // Update selected department when the faculty changes
                          selectedDepartment = faculties
                              .firstWhere((f) => f.name == selectedFaculty)
                              .departments
                              .first
                              .name;
                        });
                      },
                      items: faculties.map<DropdownMenuItem<String>>((Faculty faculty) {
                        return DropdownMenuItem<String>(
                          value: faculty.name,
                          child: Text(faculty.name),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      hint: Text('Select Department'),
                      value: selectedDepartment,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDepartment = newValue!;
                        });
                      },
                      items: faculties
                          .firstWhere((f) => f.name == selectedFaculty)
                          .departments
                          .map<DropdownMenuItem<String>>((Department department) {
                        return DropdownMenuItem<String>(
                          value: department.name,
                          child: Text(department.name),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        String name = nameController.text;
                        int quantity = int.tryParse(quantityController.text) ?? 0;
                        if (name.isNotEmpty && quantity > 0) {
                          addAsset(Asset(name, quantity));
                        }
                        nameController.clear();
                        quantityController.clear();
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Total Assets: ${getTotalAssets()}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
