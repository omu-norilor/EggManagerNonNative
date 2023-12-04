  class Egg {
    String name;
    String species;
    String size;
    int daysToHatch;
    late int id;

  Egg(this.name, this.species, this.size, this.daysToHatch);

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'name': name,
        'species': species,
        'size': size,
        'daysToHatch': daysToHatch,
      };
    }

    Map<String, dynamic> toMapNoId() {
      return {
        'name': name,
        'species': species,
        'size': size,
        'daysToHatch': daysToHatch,
      };
    }

    factory Egg.fromMap(Map<String, dynamic> map) {
      Egg newEgg = Egg(
        map['name'],
        map['species'],
        map['size'],
        map['daysToHatch'],

      );
      newEgg.setID(map['id']);
      return newEgg;
    }
  String getName(){
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  String getSpecies(){
    return species;
  }

  void setSpecies(String species) {
    this.species = species;
  }

  String getSize(){
    return size;
  }

  void setSize(String size) {
    this.size = size;
  }

  int getDaysToHatch(){
    return daysToHatch;
  }

  void setDaysToHatch(int daysToHatch) {
    this.daysToHatch = daysToHatch;
  }

  int getID(){
    return id;
  }
  void setID(int id) {
    this.id = id;
  }

}
