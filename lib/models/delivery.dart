class Delivery{
  int id, statusAvailability;
  String email, name, phone, codeUrlPaid, tokenFCM;
  bool status;

  Delivery({this.id, this.email, this.name, this.phone, this.status, this.codeUrlPaid, this.statusAvailability, this.tokenFCM});

  factory Delivery.fromMap(dynamic data) => Delivery(
    id: data['id'],
    email: data['email'],
    name: data['name'],
    phone: data['phone'],
    status: data['status'],
    codeUrlPaid: data['codeUrlPaid'],
    statusAvailability: data['statusAvailability'],
    tokenFCM: data['tokenFCM'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'email': email,
    'name': name,
    'phone': phone,
    'status': status,
    'codeUrlPaid': codeUrlPaid,
    'statusAvailability': statusAvailability,
    'tokenFCM': tokenFCM,
  };

}