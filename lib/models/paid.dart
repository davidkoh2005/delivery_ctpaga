class Paid{
  // ignore: non_constant_identifier_names
  int id, user_id, commerce_id, coin, percentage, statusShipping;
  // ignore: non_constant_identifier_names
  String codeUrl, nameClient,total, email, nameShipping, numberShipping, addressShipping, detailsShipping, selectShipping, priceShipping, nameCompanyPayments, date;
  // ignore: non_constant_identifier_names
  Paid({this.id, this.user_id, this.commerce_id, this.codeUrl, this.nameClient, this.total, this.coin, this.email, this.nameShipping, this.numberShipping, this.addressShipping, this.detailsShipping, this.statusShipping, this.selectShipping, this.priceShipping, this.percentage, this.nameCompanyPayments, this.date});

  factory Paid.fromMap(dynamic data) => Paid(
    id: data['id'],
    user_id: data['user_id'],
    commerce_id: data['commerce_id'],
    codeUrl: data['codeUrl'],
    nameClient: data['nameClient'],
    total: data['total'],
    coin: data['coin'],
    email: data['email'],
    nameShipping: data['nameShipping'],
    numberShipping: data['numberShipping'],
    addressShipping: data['addressShipping'],
    detailsShipping: data['detailsShipping'],
    selectShipping: data['selectShipping'],
    priceShipping: data['priceShipping'],
    statusShipping: data['statusShipping'],
    percentage: data['percentage'],
    nameCompanyPayments: data['nameCompanyPayments'],
    date: data['date'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'user_id': user_id,
    'commerce_id': commerce_id,
    'codeUrl': codeUrl,
    'nameClient': nameClient,
    'total': total,
    'coin': coin,
    'email': email,
    'nameShipping': nameShipping,
    'numberShipping': numberShipping,
    'addressShipping': addressShipping,
    'detailsShipping': detailsShipping,
    'selectShipping': selectShipping,
    'priceShipping': priceShipping,
    'statusShipping': statusShipping,
    'percentage': percentage,
    'nameCompanyPayments': nameCompanyPayments,
    'date': date,
  };

}