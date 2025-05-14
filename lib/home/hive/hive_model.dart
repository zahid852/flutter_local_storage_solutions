import 'package:hive/hive.dart';
part 'hive_model.g.dart';

@HiveType(typeId: 0)
class HiveUserModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String role;

  HiveUserModel({required this.name, required this.role});
}
