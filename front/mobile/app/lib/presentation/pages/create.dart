import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/config/constants.dart';
import '/data/models/data.dart';
import '/data/sources/storage_service.dart';
import '/data/sources/request_service.dart';
import '/presentation/providers/language.dart';
import '/presentation/layouts/appbar.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class ActionReaction {
  final String name;
  final String description;
  final String service;
  final Map<String, dynamic> params;

  ActionReaction({
    required this.name,
    required this.description,
    required this.service,
    required this.params,
  });

  factory ActionReaction.fromJson(Map<String, dynamic> json) {
    return ActionReaction(
      name: json['name'],
      description: json['description'],
      service: json['service'],
      params: json['params'],
    );
  }
}

class _CreatePageState extends State<CreatePage> {
  String? errorMessage;
  bool showAreas = true;

  List<ActionReaction> allActions = [];
  List<dynamic> allActionsServices = [];
  String? selectedActionService;
  ActionReaction? selectedAction;

  List<ActionReaction> allReactions = [];
  List<dynamic> allReactionsServices = [];
  String? selectedReactionService;
  ActionReaction? selectedReaction;

  Map<String, TextEditingController> actionParamControllers = {};
  Map<String, TextEditingController> reactionParamControllers = {};

  final StorageService _storageService = StorageService();
  final RequestService _requestService = const RequestService();

  Future<void> createArea() async {
    if (selectedAction == null || selectedReaction == null) {
      setState(() {
      errorMessage = translate('selectActionAndReactionError');
      });
      return;
    }
    final actionParams = actionParamControllers.map((key, controller) => MapEntry(key, controller.text));
    final reactionParams = reactionParamControllers.map((key, controller) => MapEntry(key, controller.text));
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final response = await _requestService.makeRequest<bool>(
      endpoint: '/area/create?action=${Uri.encodeComponent(selectedAction!.name)}&reaction=${Uri.encodeComponent(selectedReaction!.name)}&action_params=${Uri.encodeComponent(json.encode(actionParams))}&reaction_params=${Uri.encodeComponent(json.encode(reactionParams))}',
      method: 'POST',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) => response.statusCode == 200,
    );

    if (response is DataSuccess) {
    } else if (response is DataError) {
      setState(() {
      errorMessage = '${translate('subscribeToAreaError')}: ${response.data}';
      });
    }
  }

  Future<void> fetchAllActions() async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final response = await _requestService.makeRequest<List<dynamic>>(
      endpoint: '/area/get/actions',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) {
        final responseBody = response.body;
        return json.decode(responseBody)['actions'];
      },
    );

    if (response is DataSuccess) {
      setState(() {
        allActions = (response.data as List)
            .map((actionJson) => ActionReaction.fromJson(actionJson))
            .toList();
        allActionsServices = allActions.map((action) => action.service).toSet().toList();
      });
    } else if (response is DataError) {
      setState(() {
        errorMessage = '${translate('fetchSubscribedAreasError')}: ${response.error}';
      });
    }
  }

  Future<void> fetchAllReactions() async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final response = await _requestService.makeRequest<List<dynamic>>(
      endpoint: '/area/get/reactions',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) {
        final responseBody = response.body;
        return json.decode(responseBody)['reactions'];
      },
    );

    if (response is DataSuccess) {
      setState(() {
        allReactions = (response.data as List)
            .map((reactionJson) => ActionReaction.fromJson(reactionJson))
            .toList();
        allReactionsServices = allReactions.map((reaction) => reaction.service).toSet().toList();
      });
    } else if (response is DataError) {
      setState(() {
        errorMessage = '${translate('fetchSubscribedAreasError')}: ${response.error}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllActions();
    fetchAllReactions();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surfaceTint,
          appBar: CustomAppBar(title: "Create Area", hideAccountButton: true),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Color(0xFFB23737),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: theme.colorScheme.shadow,
                    child: ListTile(
                      title: Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0, left: 32.0, right: 32.0),
                      child: Text(
                        "Action",
                        style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        ),
                      ),
                      ),
                      subtitle: Padding(
                      padding: const EdgeInsets.only(
                      bottom: 16.0, left: 32.0, right: 32.0),
                      child: Column(
                        children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton<String>(
                            hint: Text("Select Service", style: TextStyle(color: Colors.white)),
                            value: selectedActionService,
                            dropdownColor: Colors.black,
                            onChanged: (String? newValue) {
                            setState(() {
                              selectedActionService = newValue;
                              selectedAction = null;
                              actionParamControllers.clear();
                            });
                            },
                            items: allActionsServices.map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(color: Colors.white)),
                            );
                            }).toList(),
                          ),
                        ),
                        if (selectedActionService != null)
                          Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton<ActionReaction>(
                            hint: Text("Select Action", style: TextStyle(color: Colors.white)),
                            value: selectedAction,
                            dropdownColor: Colors.black,
                            onChanged: (ActionReaction? newValue) {
                            setState(() {
                              selectedAction = newValue;
                              actionParamControllers.clear();
                              if (selectedAction != null) {
                              selectedAction!.params.forEach((key, value) {
                                actionParamControllers[key] = TextEditingController();
                              });
                              }
                            });
                            },
                            items: allActions
                              .where((action) => action.service == selectedActionService)
                              .map<DropdownMenuItem<ActionReaction>>((ActionReaction value) {
                            return DropdownMenuItem<ActionReaction>(
                              value: value,
                              child: Text(value.name, style: TextStyle(color: Colors.white)),
                            );
                            }).toList(),
                          ),
                          ),
                        if (selectedAction != null)
                          ...selectedAction!.params.keys.map((String key) {
                          return TextField(
                            controller: actionParamControllers[key],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                            labelText: key,
                            labelStyle: TextStyle(color: Colors.white),
                            ),
                          );
                          }).toList(),
                        ],
                      ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                  child: Card(
                    color: Color(0xFF0F4FC7),
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
                        "Reaction",
                        style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'IstokWeb',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        ),
                      ),
                      ),
                      subtitle: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16.0, left: 32.0, right: 32.0),
                      child: Column(
                        children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton<String>(
                          hint: Text("Select Service", style: TextStyle(color: Colors.white)),
                          value: selectedReactionService,
                          dropdownColor: Colors.black,
                          onChanged: (String? newValue) {
                            setState(() {
                            selectedReactionService = newValue;
                            selectedReaction = null;
                            reactionParamControllers.clear();
                            });
                          },
                          items: allReactionsServices.map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          ),
                        ),
                        if (selectedReactionService != null)
                          Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton<ActionReaction>(
                            hint: Text("Select Reaction", style: TextStyle(color: Colors.white)),
                            value: selectedReaction,
                            dropdownColor: Colors.black,
                            onChanged: (ActionReaction? newValue) {
                            setState(() {
                              selectedReaction = newValue;
                              reactionParamControllers.clear();
                              if (selectedReaction != null) {
                              selectedReaction!.params.forEach((key, value) {
                                reactionParamControllers[key] = TextEditingController();
                              });
                              }
                            });
                            },
                            items: allReactions
                              .where((reaction) => reaction.service == selectedReactionService)
                              .map<DropdownMenuItem<ActionReaction>>((ActionReaction value) {
                            return DropdownMenuItem<ActionReaction>(
                              value: value,
                              child: Text(value.name, style: TextStyle(color: Colors.white)),
                            );
                            }).toList(),
                          ),
                          ),
                        if (selectedReaction != null)
                          ...selectedReaction!.params.keys.map((String key) {
                          return TextField(
                            controller: reactionParamControllers[key],
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                            labelText: key,
                            labelStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          );
                          }).toList(),
                        ],
                      ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          floatingActionButton: Semantics(
            label: 'Create Area',
            button: true,
            enabled: true,
            excludeSemantics: true,
            child: FloatingActionButton(
            onPressed: () {
              createArea();
            },
            backgroundColor: theme.colorScheme.primary,
            child: Icon(Icons.done, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}