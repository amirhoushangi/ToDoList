import 'package:flutter_application_1/data/data.dart';
import 'package:flutter_application_1/data/source/source.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveTaskDataSource implements DataSource<TaskEntity> {
  final Box<TaskEntity> box;

  HiveTaskDataSource(this.box);
  @override
  Future<TaskEntity> createOrUpdate(TaskEntity data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(TaskEntity data) async {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<TaskEntity> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchkeyword = ''}) async {
    if (searchkeyword.isNotEmpty) {
      return box.values
          .where((task) => task.name.contains(searchkeyword))
          .toList();
    } else {
      return box.values.toList();
    }
  }
}
