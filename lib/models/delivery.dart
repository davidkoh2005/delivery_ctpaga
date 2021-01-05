class Delivery{
  int id;
  String email, name, phone;
  bool status;

  Delivery({this.id, this.email, this.name, this.phone, this.status});

  factory Delivery.fromMap(dynamic data) => Delivery(
    id: data['id'],
    email: data['email'],
    name: data['name'],
    phone: data['phone'],
    status: data['status'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'email': email,
    'name': name,
    'phone': phone,
    'status': status,
  };

}