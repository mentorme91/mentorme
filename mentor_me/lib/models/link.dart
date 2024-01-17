class MyLink {
  String title, details, link;
  MyLink({required this.title, required this.details, required this.link});

  Map<String, dynamic> toMap() {
    return {'title': title, 'details': details, 'link': link};
  }
}
