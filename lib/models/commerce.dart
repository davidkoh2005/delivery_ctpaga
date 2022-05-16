class Commerce{
  String? rif, name, address, phone, userUrl;

  Commerce({this.rif, this.name, this.address, this.phone, this.userUrl});

  factory Commerce.fromMap(dynamic data) => Commerce(
    rif: data['rif'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
    userUrl: data['userUrl'],
  );

  Map<String, dynamic> toJson()=> {
    'rif': rif,
    'name': name,
    'address': address,
    'phone': phone,
    'userUrl': userUrl,
  };

}