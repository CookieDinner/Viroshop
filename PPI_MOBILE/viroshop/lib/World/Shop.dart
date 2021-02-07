class Shop {
  final int id;
  final String city;
  final String street;
  final int number;
  final String name;
  final int maxReservationsPerQuarterOfHour;
  Shop(this.id, this.city, this.street, this.number, this.name, this.maxReservationsPerQuarterOfHour);

  Shop.fromJson(Map<String, dynamic> json) :
        id = json["id"],
        city = json["city"],
        street = json["street"],
        number = json["number"],
        name = json["name"],
        maxReservationsPerQuarterOfHour = json["maxReservationsPerQuarterOfHour"];
}
