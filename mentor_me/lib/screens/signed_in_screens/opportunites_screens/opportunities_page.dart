import 'package:flutter/material.dart';

import '../../../themes.dart';
import 'grad_school.dart';
import 'new_grad.dart';
import 'others.dart';
import 'scholarships.dart';
import 'internships.dart';

class OpportunitiesPage extends StatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage> {
  final Map<String, Map<String, dynamic>> _opportunites = {
    'Scholarships': {
      'image': 'assets/images/scholarships.jpg',
      'name': 'Scholarships',
      'page': const ScholarshipsPage()
    },
    'Internships': {
      'image': 'assets/images/internship.jpg',
      'name': 'Internships',
      'page': const InternShipsPage()
    },
    'New Grad roles': {
      'image': 'assets/images/other_jobs.jpeg',
      'name': 'New Grad roles',
      'page': const NewGradRolesPage()
    },
    'Job opportunities': {
      'image': 'assets/images/other_jobs.jpeg',
      'name': 'Other job opportunities',
      'page': const OtherOpportunitiesPage()
    },
    'Graduate programs': {
      'image': 'assets/images/grad_school.jpeg',
      'name': 'Graduate programs',
      'page': const GradSchoolPage()
    },
  };

  Widget _buildListTile(Map<String, dynamic> info) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: boxDecoration(Theme.of(context), 20),
      child: ListTile(
        leading: CircleAvatar(
          foregroundImage: AssetImage(info['image']),
        ),
        title: Text(
          info['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        onTap: () {
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => info['page'])));
          });
        },
      ),
    );
  }

  String searchVal = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.opp,
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
            ] +
            _opportunites
                .map((key, value) => MapEntry(key, _buildListTile(value)))
                .values
                .toList(),
      ),
    );
  }
}
