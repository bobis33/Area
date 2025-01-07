import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/data/models/data.dart';
import '/data/sources/request_service.dart';
import '/presentation/providers/language.dart';

class AreasPage extends StatefulWidget {
  const AreasPage({super.key});

  @override
  State<AreasPage> createState() => _AreasPageState();
}

class _AreasPageState extends State<AreasPage> {
  List<dynamic> areas = [];
  Map<String, String> userEmails = {};
  String userEmail = '';
  List<dynamic> subscribedAreas = [
    {
      'action': 'when a pull request is merged',
      'reaction': 'receive a mail',
      'color': 0xFFB23737
    },
    {
      'action': 'when invited to a chess.com game',
      'reaction': 'receive a discord message',
      'color': 0xFF379E4A
    },
    {
      'action': 'when a disord message is received',
      'reaction': 'save it to google sheets',
      'color': 0xFF0F4FC7
    },
  ];
  String newAction = '';
  String newReaction = '';
  String? errorMessage;
  bool showAreas = true;

  final RequestService _requestService = const RequestService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: Color(0xFF272727),
          appBar: AppBar(
            title: Text(
              'My AREAS',
              style: TextStyle(
                fontFamily: 'IstokWeb',
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            toolbarHeight: 80,
            backgroundColor: Color(0xFF343434),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ] else ...[
                    ListView.builder(
                      // Display subscribed areas
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: subscribedAreas.length,
                      itemBuilder: (context, index) {
                        final area = subscribedAreas[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Color(area['color']),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 32.0, right: 32.0),
                                child: Text(
                                  area['action'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'IstokWeb',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 16.0, left: 32.0, right: 32.0),
                                child: Text(
                                  area['reaction'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'IstokWeb',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  // Create new area button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      color: Color(0xFF1F1F1F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.add,
                            color: Color(0xFF8E8E8E),
                            size: 40,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 16.0, right: 32.0),
                          child: Text(
                            'Create New Area',
                            style: TextStyle(
                              color: Color(0xFF8E8E8E),
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onTap: () {
                          // Handle the tap event to create a new area
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
