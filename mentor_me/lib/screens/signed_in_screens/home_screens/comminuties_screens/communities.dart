import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../theme_provider.dart';

class CommunitiesPageThemeLoader extends StatelessWidget {
  const CommunitiesPageThemeLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(data: theme, child: CommunitiesPage());
  }
}

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  String searchVal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Center(
            child: Text(
              'Find a Community',
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
                        hintText: 'Search Communities',
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
        ],
      ),
    );
  }
}
