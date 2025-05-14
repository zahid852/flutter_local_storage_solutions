import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_storage_solutions/home/hive/hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({super.key});

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  late final Directory appDocumentDirectory;
  late Future<void> hiveInitialization;
  late Box<HiveUserModel> box;
  @override
  void initState() {
    hiveInitialization = initializeHive();
    super.initState();
  }

  Future<void> initializeHive() async {
    appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    if (!Hive.isAdapterRegistered(HiveUserModelAdapter().typeId)) {
      Hive.registerAdapter(HiveUserModelAdapter());
    }

    //adapter means registering a custom datatype in hive like string, int already stored in it
    box = await Hive.openBox<HiveUserModel>('user-data');
    //box means collection or table
  }

  void manageProfileInfo(bool isEdit, {HiveUserModel? model}) {
    TextEditingController nameController =
        TextEditingController(text: isEdit ? model!.name : '');
    TextEditingController roleController =
        TextEditingController(text: isEdit ? model!.role : '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('${isEdit ? 'Edit' : 'Create'} User'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: roleController,
                style: TextStyle(fontSize: 14, color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'Role',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (isEdit) {
                  model!.name = nameController.text;
                  model.role = roleController.text;
                  model.save();
                  // this is for, if you want to auto update the box when that model value changes without calling any method
                } else {
                  HiveUserModel model = HiveUserModel(
                      name: nameController.text, role: roleController.text);
                  box.add(model);
                }
                nameController.clear();
                roleController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hive')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          manageProfileInfo(
            false,
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: FutureBuilder(
            future: hiveInitialization,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              return ValueListenableBuilder<Box<HiveUserModel>>(
                  valueListenable: box.listenable(),
                  builder: (ctx, box, _) {
                    List<HiveUserModel> data = box.values.toList();
                    if (data.isEmpty) {
                      return Center(
                        child: Text('+ Add Users'),
                      );
                    }
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final HiveUserModel model = data[index];
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, right: 4, top: 10, bottom: 10),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                title: Text(
                                  model.name,
                                ),
                                subtitle: Text(model.role),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          manageProfileInfo(true, model: model);
                                        },
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: Colors.blue,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          model.delete();
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                height: 1,
                              ),
                            )
                          ],
                        );
                      },
                    );
                  });
            }),
      )),
    );
  }
}
