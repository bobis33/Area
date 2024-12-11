import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/models/data.dart';
import '/providers/language.dart';
import '/services/request.dart';

class AreasPage extends StatefulWidget {
  const AreasPage({super.key});

  @override
  State<AreasPage> createState() => _AreasPageState();
}

class _AreasPageState extends State<AreasPage> {
  List<dynamic> areas = [];
  Map<String, String> userEmails = {};
  String userEmail = '';
  List<dynamic> subscribedAreas = [];
  String newAction = '';
  String newReaction = '';
  String? errorMessage;
  bool showAreas = true;

  final RequestService _requestService = const RequestService();

  @override
  void initState() {
    super.initState();
    fetchAreas();
  }

  Future<void> fetchAreas() async {
    final response = await _requestService.makeRequest(
      endpoint: '/area/get/all',
      method: 'GET',
      parse: (response) => json.decode(response.body)['areas'],
    );

    if (response is DataSuccess) {
      setState(() {
        areas = response.data;
      });
    } else if (response is DataError) {
      setState(() {
        errorMessage = '${translate('fetchAreasError')}: ${response.error}';
      });
    }
  }

  Future<void> createArea() async {
    setState(() {
      errorMessage = null;
    });

    try {
      final response = await _requestService.makeRequest(
        endpoint: '/area/create?action=$newAction&reaction=$newReaction',
        method: 'POST',
        parse: (response) => json.decode(response.body),
      );

      if (response is DataSuccess) {
        fetchAreas();
      } else if (response is DataError) {
        setState(() {
          errorMessage = '${translate('createAreaError')}: ${response.error}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '${translate('createAreaError')}: $e';
      });
    }
  }

  Future<void> subscribeUser(String areaId) async {
    final email = userEmail;
    if (email.isEmpty) {
      setState(() {
        errorMessage = translate('emailInvalid');
      });
      return;
    }

    final response = await _requestService.makeRequest(
      endpoint: '/area/subscribe?user_email=$email&area_id=$areaId',
      method: 'POST',
      parse: (response) => json.decode(response.body),
    );

    if (response is DataSuccess) {
      fetchSubscribedAreas();
    } else if (response is DataError) {
      setState(() {
        errorMessage = '${translate('subscribeError')}: ${response.error}';
      });
    }
  }

  Future<void> unsubscribeUser(String areaId) async {
    if (userEmail.isEmpty) {
      setState(() {
        errorMessage = translate('emailInvalid');
      });
      return;
    }

    final response = await _requestService.makeRequest(
      endpoint: '/area/unsubscribe',
      method: 'POST',
      body: {'user_email': userEmail, 'area_id': areaId},
      parse: (response) => json.decode(response.body),
    );

    if (response is DataSuccess) {
      fetchSubscribedAreas();
    } else if (response is DataError) {
      setState(() {
        errorMessage = '${translate('unsubscribeError')}: ${response.error}';
      });
    }
  }

  Future<void> fetchSubscribedAreas() async {
    if (userEmail.isEmpty) {
      setState(() {
        errorMessage = translate('emailInvalid');
      });
      return;
    }

    final response = await _requestService.makeRequest(
      endpoint: '/area/get/subscribed?user_email=$userEmail',
      method: 'GET',
      parse: (response) => json.decode(response.body)['subscribed_areas'],
    );

    if (response is DataSuccess) {
      setState(() {
        subscribedAreas = response.data;
      });
    } else if (response is DataError) {
      setState(() {
        errorMessage = '${translate('fetchSubscribedAreasError')}: ${response.error}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(translate('areas')),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('All Areas', style: Theme.of(context).textTheme.headlineSmall),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: fetchAreas,
                        child: Text('Fetch Areas'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAreas = !showAreas;
                          });
                        },
                        child: Text(showAreas ? 'Hide Areas' : 'Show Areas'),
                      ),
                    ],
                  ),
                  if (showAreas)
                    areas.isNotEmpty
                      ? Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: areas.length,
                            itemBuilder: (context, index) {
                            final area = areas[index];
                            return ListTile(
                              title: Text('Action: ${area['action']}'),
                              subtitle: Text('Reaction: ${area['reaction']}'),
                              trailing: ElevatedButton(
                              onPressed: () => subscribeUser(area['_id']),
                              child: Text('Subscribe'),
                              ),
                            );
                            },
                            ),
                          ],
                          )
                          : Text('No areas found.'),
                  SizedBox(height: 20),
                  Text('Subscribed Areas', style: Theme.of(context).textTheme.headlineSmall),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        userEmail = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your email to see subscribed areas',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: fetchSubscribedAreas,
                    child: Text('Fetch Subscribed Areas'),
                  ),
                  subscribedAreas.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: subscribedAreas.length,
                          itemBuilder: (context, index) {
                            final area = subscribedAreas[index];
                            return ListTile(
                              title: Text('Action: ${area['action']}'),
                              subtitle: Text('Reaction: ${area['reaction']}'),
                              trailing: ElevatedButton(
                                onPressed: () => unsubscribeUser(area['_id']),
                                child: Text('Unsubscribe'),
                              ),
                            );
                          },
                        )
                      : Text('No subscribed areas found.'),
                  SizedBox(height: 20),
                  Text('Create New Area', style: Theme.of(context).textTheme.headlineSmall),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        newAction = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Action',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        newReaction = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Reaction',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: createArea,
                    child: Text('Create Area'),
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
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