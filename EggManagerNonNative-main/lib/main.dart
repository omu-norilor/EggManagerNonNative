import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'egg_data_model.dart';
import 'egg.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EggDataModel(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedEggIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Egg Manager'),
      ),
      body: Column(
        children: [
          Consumer<EggDataModel>(
            builder: (context, eggDataModel, child) {
              return Expanded(
                child: ListView.builder(
                  itemCount: eggDataModel.eggList.length,
                  itemBuilder: (context, index) {
                    Egg egg = eggDataModel.eggList[index];
                    return ListTile(
                      title: Text(egg.name),
                      subtitle: Text(egg.species),
                      trailing: Text('Size: ${egg.size}, Days to Hatch: ${egg.daysToHatch}'),
                      onTap: () {
                        setState(() {
                          selectedEggIndex = index;
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedEggIndex != -1 && selectedEggIndex < Provider.of<EggDataModel>(context).eggList.length)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected Egg:'),
                      Text('Name: ${Provider.of<EggDataModel>(context).eggList[selectedEggIndex].name}'),
                      Text('ID: ${Provider.of<EggDataModel>(context).eggList[selectedEggIndex].id}'),
                    ],
                  ),
                if (selectedEggIndex == -1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No Egg selected.'),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: selectedEggIndex != -1
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateEggScreen(selectedEggIndex: selectedEggIndex),
                          ),
                        );
                      }
                          : null,
                      child: Text('Update Egg'),
                    ),
                    ElevatedButton(
                      onPressed: selectedEggIndex != -1
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeleteEggScreen(selectedEggIndex: selectedEggIndex),
                          ),
                        );
                      }
                          : null,
                      child: Text('Delete Egg'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateEggScreen(),
                          ),
                        );
                      },
                      child: Text('Create Egg'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class CreateEggScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController daysToHatchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Egg'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: speciesController,
              decoration: InputDecoration(labelText: 'Species'),
            ),
            TextFormField(
              controller: sizeController,
              decoration: InputDecoration(labelText: 'Size'),
            ),
            TextFormField(
              controller: daysToHatchController,
              decoration: InputDecoration(labelText: 'Days to Hatch'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Egg newEgg = Egg(
                  nameController.text,
                  speciesController.text,
                  sizeController.text,
                  int.tryParse(daysToHatchController.text) ?? 0,
                );

                Provider.of<EggDataModel>(context, listen: false).addEgg(newEgg);

                Navigator.pop(context); // Close the create egg screen
              },
              child: Text('Create Egg'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateEggScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController daysToHatchController = TextEditingController();

  final int selectedEggIndex;

  UpdateEggScreen({required this.selectedEggIndex});

  @override
  Widget build(BuildContext context) {
    // Retrieve the selected egg from the EggDataModel
    Egg selectedEgg = Provider.of<EggDataModel>(context).eggList[selectedEggIndex];

    // Set the controllers with the values of the selected egg
    nameController.text = selectedEgg.name;
    speciesController.text = selectedEgg.species;
    sizeController.text = selectedEgg.size;
    daysToHatchController.text = selectedEgg.daysToHatch.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Egg'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: speciesController,
              decoration: InputDecoration(labelText: 'Species'),
            ),
            TextFormField(
              controller: sizeController,
              decoration: InputDecoration(labelText: 'Size'),
            ),
            TextFormField(
              controller: daysToHatchController,
              decoration: InputDecoration(labelText: 'Days to Hatch'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Create an updated egg with the new values
                Egg updatedEgg = Egg(
                  nameController.text,
                  speciesController.text,
                  sizeController.text,
                  int.tryParse(daysToHatchController.text) ?? 0,
                );
                updatedEgg.setID(selectedEggIndex);

                // Update the egg using the EggDataModel
                Provider.of<EggDataModel>(context, listen: false).updateEgg(updatedEgg);

                Navigator.pop(context); // Close the update egg screen
              },
              child: Text('Update Egg'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteEggScreen extends StatelessWidget {
  final int selectedEggIndex;

  DeleteEggScreen({required this.selectedEggIndex});

  @override
  Widget build(BuildContext context) {
    String selectedEggName = Provider.of<EggDataModel>(context).eggList[selectedEggIndex].name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Egg'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Are you sure you want to delete egg $selectedEggName?'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Delete the selected egg
                Provider.of<EggDataModel>(context, listen: false).deleteEgg(selectedEggIndex);
                Navigator.pop(context); // Close the delete egg screen
              },
              child: Text('YES'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the delete egg screen
              },
              child: Text('NO'),
            ),
          ],
        ),
      ),
    );
  }
}
