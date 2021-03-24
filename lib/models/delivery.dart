class Delivery{
  int id, status, statusAvailability;
  String email, name, phone, codeUrlPaid, tokenFCM, model, mark, colors, licensePlate;

  Delivery({this.id, this.email, this.name, this.phone, this.status, this.codeUrlPaid, this.statusAvailability, this.tokenFCM, this.model, this.mark, this.colors, this.licensePlate});

  factory Delivery.fromMap(dynamic data) => Delivery(
    id: data['id'],
    email: data['email'],
    name: data['name'],
    phone: data['phone'],
    status: data['status'],
    codeUrlPaid: data['codeUrlPaid'],
    statusAvailability: data['statusAvailability'],
    tokenFCM: data['tokenFCM'],
    model: data['model'],
    mark: data['mark'],
    colors: data['colors'],
    licensePlate: data['licensePlate'],
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
    'model': model,
    'mark': mark,
    'colors': colors,
    'licensePlate': licensePlate,
  };

}