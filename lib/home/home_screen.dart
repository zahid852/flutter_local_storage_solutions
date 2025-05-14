import 'package:flutter/material.dart';
import 'package:local_storage_solutions/home/route_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List> data = [
    ['Sqflite', Routes.sqfLite],
    ['Hive', Routes.hive],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Local Storage Solutions',
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: List.generate(data.length, (index) {
            final List solution = data[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.blue,
                  ),
                ),
                minLeadingWidth: 10,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                tileColor: Colors.blueGrey[100],
                onTap: () {
                  Navigator.of(context).pushNamed(solution[1]);
                },
                title: Text(solution[0],
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            );
          }),
        ),
      ),
    );
  }
}
