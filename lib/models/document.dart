class Document{
  // ignore: non_constant_identifier_names
  int? id;
  String? description, url;

  // ignore: non_constant_identifier_names
  Document({this.id, this.description, this.url, });

  factory Document.fromMap(dynamic data) => Document(
    id: data['id'],
    description: data['description'],
    url: data['url'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'description': description,
    'url': url,
  };

}