import 'package:flutter/material.dart';
import 'egg.dart'; // Import the egg.dart file
import 'egg_data_model.dart';

int ID = 0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final EggDataModel eggDataModel = EggDataModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(eggDataModel: eggDataModel),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final EggDataModel eggDataModel;

  HomeScreen({required this.eggDataModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Egg Manager"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      CreateEggScreen(eggDataModel: eggDataModel)),
                );
              },
              child: Text("Create Egg"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      ReadEggsScreen(eggDataModel: eggDataModel)),
                );
              },
              child: Text("See Eggs"),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateEggScreen extends StatelessWidget {
  final EggDataModel eggDataModel;

  CreateEggScreen({required this.eggDataModel});

  TextEditingController nameController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  String selectedSize = "Small";
  TextEditingController daysToHatchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Egg"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: speciesController,
              decoration: InputDecoration(
                hintText: "Species",
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: selectedSize,
              items: ["Small", "Medium", "Large"].map((String size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text(size),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  selectedSize = value;
                }
              },
              decoration: InputDecoration(
                hintText: "Size",
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: daysToHatchController,
              decoration: InputDecoration(
                hintText: "Days to Hatch",
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final newEgg = Egg(
                  nameController.text,
                  speciesController.text,
                  selectedSize,
                  int.tryParse(daysToHatchController.text) ?? 0,
                );
                eggDataModel.addEgg(newEgg);
                Navigator.pop(context);
              },
              child: Text("Create Egg"),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadEggsScreen extends StatefulWidget {
  final EggDataModel eggDataModel;

  ReadEggsScreen({required this.eggDataModel});

  @override
  _ReadEggsScreenState createState() => _ReadEggsScreenState();
}

class _ReadEggsScreenState extends State<ReadEggsScreen> {
  int selectedEggIndex = -1;
  int selectedEggID = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Egg List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.eggDataModel.eggList.length,
                itemBuilder: (context, index) {
                  Egg egg = widget.eggDataModel.eggList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedEggIndex = egg.getID();
                        selectedEggID = index;
                      });
                    },
                    child: ListTile(
                      title: Text(egg.name),
                      subtitle: Text(egg.species),
                      trailing: Text("Size: ${egg.size}, Days to Hatch: ${egg.daysToHatch}, ID: ${egg.getID()}"),
                    ),
                  );
                },
              ),
            ),
            if (selectedEggIndex != -1) // Display details only when an egg is selected.
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selected Egg with name: ${widget.eggDataModel.eggList[selectedEggID].name} and ID: ${widget.eggDataModel.eggList[selectedEggID].getID()}"),
                  ],
                ),
              ),
            if (selectedEggIndex == -1) // Display a message when no egg is selected.
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No Egg selected."),
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (selectedEggIndex != -1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteEggScreen(eggDataModel: widget.eggDataModel, eggIndex: selectedEggIndex, eggID: selectedEggID),
                    ),
                  );
                }
              },
              child: Text("Delete selected Egg"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (selectedEggIndex != -1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateEggScreen(eggDataModel: widget.eggDataModel, eggIndex: selectedEggIndex),

                    ),
                  );
                }
              },
              child: Text("Edit selected Egg"),
            ),
          ],
        ),
      ),
    );
  }
}




class DeleteEggScreen extends StatelessWidget {
  final EggDataModel eggDataModel;
  final int eggIndex;
  final int eggID;

  DeleteEggScreen({required this.eggDataModel, required this.eggIndex, required this.eggID});

  @override
  Widget build(BuildContext context) {
    String selectedEggName = eggDataModel.eggList[eggIndex].name;

    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Egg"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Are you sure you want to delete egg with name $selectedEggName?"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                eggDataModel.deleteEgg(eggID);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadEggsScreen(eggDataModel: eggDataModel),

                  ),
                );
              },
              child: Text("YES"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadEggsScreen(eggDataModel: eggDataModel),

                  ),
                );
              },
              child: Text("NO"),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateEggScreen extends StatelessWidget {
  final EggDataModel eggDataModel;
  final int eggIndex;

  UpdateEggScreen({required this.eggDataModel, required this.eggIndex});

  @override
  Widget build(BuildContext context) {
    // Get the selected egg based on the provided index.
    Egg selectedEgg = eggDataModel.eggList[eggIndex];

    TextEditingController nameController = TextEditingController(text: selectedEgg.name);
    TextEditingController speciesController = TextEditingController(text: selectedEgg.species);
    String selectedSize = selectedEgg.size;
    TextEditingController daysToHatchController =
    TextEditingController(text: selectedEgg.daysToHatch.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Egg"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: speciesController,
              decoration: InputDecoration(
                hintText: "Species",
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: selectedSize,
              items: ["Small", "Medium", "Large"].map((String size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text(size),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  selectedSize = value;
                }
              },
              decoration: InputDecoration(
                hintText: "Size",
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: daysToHatchController,
              decoration: InputDecoration(
                hintText: "Days to Hatch",
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Update the selected egg with the new values
                Egg updatedEgg = Egg(
                  nameController.text,
                  speciesController.text,
                  selectedSize,
                  int.tryParse(daysToHatchController.text) ?? 0,
                );
                updatedEgg.setID(eggIndex);

                // Call the updateEgg method in EggDataModel
                eggDataModel.updateEgg(updatedEgg);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadEggsScreen(eggDataModel: eggDataModel),

                  ),
                );
              },
              child: Text("Update Egg"),
            ),
          ],
        ),
      ),
    );
  }
}


int onEggSelected(List<Egg> eggList, int list_index) {
  return eggList[list_index].getID();
  //get the index of the selected egg from the egg list
}


void updateEgg(List<Egg> eggList, Egg new_egg) {
  for (int i = 0; i < eggList.length; i++) {
    if (eggList[i].getID() == new_egg.getID()) {
      eggList[i] = new_egg;
      break;
    }
  }
}

void addEgg(List<Egg> eggList, Egg new_egg) {
  new_egg.setID(ID);
  ID++;
  eggList.add(new_egg);
}

void deleteEgg(List<Egg> eggList, int index) {
  for (int i = 0; i < eggList.length; i++) {
    if (eggList[i].getID() == index) {
      eggList.removeAt(i);
      break;
    }
  }
}

List<Egg> init_list() {
  List<Egg> eggList = [];
  addEgg(eggList, Egg("Mirela", "Gallus gallus domesticus", "Medium", 15));
  addEgg(eggList, Egg("Doru", "Falco", "Small", 3));
  addEgg(eggList, Egg("Ionica", "Dromaius novaehollandiae", "Large", 30));
  addEgg(eggList, Egg("Janos", "Paridae", "Small", 22));
  return eggList;
}

