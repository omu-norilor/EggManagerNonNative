class Egg {
  String name;
  String species;
  String size;
  int daysToHatch;
  int id= -1;

  Egg(this.name, this.species, this.size, this.daysToHatch);

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
