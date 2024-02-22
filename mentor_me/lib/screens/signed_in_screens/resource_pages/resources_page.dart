import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

import '../../../services/json_decoder.dart';
import 'course_resource.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  List<Widget> _createCourseTile(List<String> courses) {
    return courses.map((course) => CourseTile(courseCode: course)).toList();
  }

  List<String> courses = [];

  List<String> _filterCourses(List<String> courses) {
    List<String> filter = [];
    if (searchVal == '') {
      return courses;
    }
    searchVal = searchVal.toUpperCase();
    for (var element in courses) {
      if (element.substring(0, searchVal.length) == searchVal) {
        filter.add(element);
      }
    }
    return filter;
  }

  Future<List<String>> _getCourses() async {
    List<String> courses = [];
    Map<String, dynamic> jsonMap = await loadJsonData('schools_info.json');
    for (var school in jsonMap.keys.toList()) {
      for (var faculty
          in (jsonMap[school] as Map<String, dynamic>).keys.toList()) {
        for (var dept in (jsonMap[school][faculty] as Map<String, dynamic>)
            .keys
            .toList()) {
          for (var course in jsonMap[school][faculty][dept] as List<dynamic>) {
            if (!courses.contains(course as String)) {
              courses.add(course);
            }
          }
        }
      }
    }
    return courses;
  }

  String searchVal = '';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!.resNote,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.only(
              left: 10,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            alignment: AlignmentDirectional.center,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () => {print('Hello!')},
                ),
                Expanded(
                  child: FractionallySizedBox(
                    child: TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.resNote2,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchVal = value;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
              future: _getCourses(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                List<String> courses = snapshot.data ?? [];
                return SizedBox(
                  height: screenHeight - 245,
                  child: GridView.count(
                    crossAxisCount: 3,
                    scrollDirection: Axis.vertical,
                    children: _createCourseTile(_filterCourses(courses)),
                  ),
                );
              })),
        ],
      ),
    );
  }
}

class CourseTile extends StatelessWidget {
  final String courseCode;
  const CourseTile({required this.courseCode, super.key});

  Color _generateRandomColor() {
    // Generate random values for red, green, and blue components
    int red = Random().nextInt(256);
    int green = Random().nextInt(256);
    int blue = Random().nextInt(256);

    // Ensure that the color is not too dark by checking the luminance
    while (getColorLuminance(Color.fromRGBO(red, green, blue, 1.0)) < 0.6) {
      red = Random().nextInt(256);
      green = Random().nextInt(256);
      blue = Random().nextInt(256);
    }

    // Return the generated color
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  double getColorLuminance(Color color) {
    // Calculate the luminance of the color
    return 0.299 * color.red + 0.587 * color.green + 0.114 * color.blue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CourseResourcePage(courseCode: courseCode)));
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 0.2,
          ),
          color: _generateRandomColor(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              courseCode,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
