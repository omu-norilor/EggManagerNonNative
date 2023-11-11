import 'egg.dart'; // Import the egg.dart file
import 'package:flutter/material.dart';


class EggDataModel with ChangeNotifier {
  List<Egg> eggList = [];
  int ID = 0;

  EggDataModel(){
    addEgg(Egg("Mirela", "Gallus gallus domesticus", "Medium", 15));
    addEgg(Egg("Doru", "Falco", "Small", 3));
    addEgg(Egg("Ionica", "Dromaius novaehollandiae", "Large", 30));
    addEgg(Egg("Janos", "Paridae", "Small", 22));
  }
  void addEgg(Egg egg) {
    egg.setID(ID);
    ID++;
    eggList.add(egg);
    notifyListeners(); // Notify listeners to trigger a rebuild.
  }

  void updateEgg(Egg updatedEgg) {
    for (int i = 0; i < eggList.length; i++) {
      if (eggList[i].getID() == updatedEgg.getID()) {
        eggList[i] = updatedEgg;
        notifyListeners();
        break;
      }
    }
  }

  void deleteEgg(int index) {
    for (int i = 0; i < eggList.length; i++) {
      if (eggList[i].getID() == index) {
        eggList.removeAt(i);
        notifyListeners();
        break;
      }
    }
  }
}
