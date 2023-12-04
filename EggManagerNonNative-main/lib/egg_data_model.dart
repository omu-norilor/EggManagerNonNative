import 'package:flutter/material.dart';
import 'egg.dart';
import 'dao.dart';

class EggDataModel with ChangeNotifier {
  final EggDatabaseHelper dbHelper = EggDatabaseHelper();

  List<Egg> eggList = [];

  EggDataModel() {
    loadEggsFromDatabase(); // Load eggs from the database on initialization.
  }

  Future<void> loadEggsFromDatabase() async {
    eggList = await dbHelper.getAllEggs();
    notifyListeners();
  }

  Future<void> addEgg(Egg egg) async {
    await dbHelper.insertEgg(egg);
    await loadEggsFromDatabase();
  }

  Future<void> updateEgg(Egg updatedEgg) async {
    await dbHelper.updateEgg(updatedEgg);
    await loadEggsFromDatabase();
  }

  Future<void> deleteEgg(int id) async {
    await dbHelper.deleteEgg(id);
    await loadEggsFromDatabase();
  }
}
