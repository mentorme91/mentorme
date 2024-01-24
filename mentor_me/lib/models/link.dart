
// custom link class for course resource links
class MyLink {
  String title, details, link;
  MyLink({required this.title, required this.details, required this.link});

  // update link from map
  Map<String, dynamic> toMap() {
    return {'title': title, 'details': details, 'link': link};
  }
}
