import 'package:flutter/material.dart';

class LinkResources extends StatefulWidget {
  final String courseCode;
  const LinkResources({super.key, required this.courseCode});

  @override
  State<LinkResources> createState() => _LinkResourcesState();
}

class _LinkResourcesState extends State<LinkResources> {
  @override
  Widget build(BuildContext context) {
    return Text('hello');
  }
}
