import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BasicInfoModel {
  String id;
  String cnic;
  String fatherName;
  String birthDate;
  String address;
  BasicInfoModel(
      this.id, this.cnic, this.fatherName, this.birthDate, this.address);

  factory BasicInfoModel.fromJson(Map<String, dynamic> json) {
    return BasicInfoModel(
        json['id'] ?? '',
        json['cnic'] ?? '',
        json['fatherName'] ?? '',
        json['birthDate'] ?? '',
        json['address'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cnic': cnic,
      'fatherName': fatherName,
      'birthDate': birthDate,
      'address': address
    };
  }
}

class LocalDataSourceConstants {
  static const String databaseName = "liftData.db";
  static const int databaseVersion = 1;
  static const String basicInfoTable = 'basicInfo';
  static const String idType = 'TEXT PRIMARY KEY';
  static const String notificationIdType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String boolType = 'BOOLEAN NOT NULL';
  static const String integerType = 'INTEGER NOT NULL';
  static const String id = 'id';
}

class BasicInfoFields {
  static const String cnic = 'cnic';
  static const String fatherName = 'fatherName';
  static const String birthDate = 'birthDate';
  static const String address = 'address';
}

class LocalDataSource {
  Database? _localDatabase;
  late String path;
  String userId = 'zahid852';
  Future<Database> get getDatabaseObject async {
    if (_localDatabase != null) {
      return _localDatabase!;
    } else {
      _localDatabase = await _initLocalDatabase();
      return _localDatabase!;
    }
  }

  Future<Database> _initLocalDatabase() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path =
        '${documentDirectory.path}/${LocalDataSourceConstants.databaseName}';
    return await openDatabase(path,
        version: LocalDataSourceConstants.databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database localDatabase, int version) async {
    await localDatabase.execute('''
          CREATE TABLE ${LocalDataSourceConstants.basicInfoTable} (
            ${LocalDataSourceConstants.id} ${LocalDataSourceConstants.idType}, 
            ${BasicInfoFields.cnic} ${LocalDataSourceConstants.textType},
            ${BasicInfoFields.fatherName} ${LocalDataSourceConstants.textType},
            ${BasicInfoFields.birthDate} ${LocalDataSourceConstants.textType},
            ${BasicInfoFields.address} ${LocalDataSourceConstants.textType}
          )
          ''');
  }

  Future<void> insert(String tableName, BasicInfoModel dataModel) async {
    final db = await getDatabaseObject;
    //here only id to be changed
    try {
      final previousData = await db.query(tableName,
          where: '${LocalDataSourceConstants.id} = ?', whereArgs: [userId]);

      if (previousData.isEmpty) {
        await db.insert(tableName, dataModel.toJson());
      } else {
        await db.update(tableName, dataModel.toJson());
      }

      _localDatabase = null;
      await db.close();
    } catch (error) {
      log('error $error');
    }
  }

  Future<BasicInfoModel?> read(String tableName) async {
    try {
      final db = await getDatabaseObject;

      final storedData = await db.query(tableName,
          where: '${LocalDataSourceConstants.id} = ?', whereArgs: [userId]);
      _localDatabase = null;
      await db.close();
      if (storedData.isNotEmpty) {
        return BasicInfoModel.fromJson(storedData.first);
      } else {
        return null;
      }
    } catch (error) {
      log('error $error');
    }
    return null;
  }

  Future deleteRecord() async {
    final db = await getDatabaseObject;
    // db.execute(
    //     'DROP TABLE IF EXISTS ${LocalDataSourceConstants.basicInfoTable}');// for dropping the table
    await db.delete(
      LocalDataSourceConstants.basicInfoTable,
      where: '${LocalDataSourceConstants.id} = ?',
      whereArgs: [userId],
    );

    _localDatabase = null;
    await db.close();
  }

  Future deleteLocalDatabase() async {
    await deleteDatabase(path);
    _localDatabase = null;
    log('Database deleted');
  }
}
