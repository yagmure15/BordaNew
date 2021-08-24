class OfficesModel {
  int id;
  String name;
  int capacity;
  int area;
  String address;

  OfficesModel(
      {required this.id,
      required this.name,
      required this.capacity,
      required this.area,
       required this.address});


  factory OfficesModel.fromJson(Map<String, dynamic> json) => OfficesModel(
    id: json["id"],
    name: json["name"],
    capacity: json["capacity"],
    area: json["area"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['capacity'] = this.capacity;
    data['area'] = this.area;
    data['address'] = this.address;
    return data;
  }
}
