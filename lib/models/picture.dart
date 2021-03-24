class Picture{
  // ignore: non_constant_identifier_names
  int id;
  String description, url;

  // ignore: non_constant_identifier_names
  Picture({this.id, this.description, this.url, });

  factory Picture.fromMap(dynamic data) => Picture(
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