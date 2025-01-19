import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/config/constants.dart';
import '/data/models/data.dart';
import '/data/sources/request_service.dart';
import '/data/sources/storage_service.dart';
import '/presentation/providers/language.dart';
import '/presentation/layouts/appbar.dart';
import '/presentation/pages/create.dart';

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

  final StorageService _storageService = StorageService();
  final RequestService _requestService = const RequestService();

  Future<void> fetchSubscribedAreas() async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final response = await _requestService.makeRequest<List<dynamic>>(
      endpoint: '/area/get/subscribed',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) => json.decode(response.body)['subscribed_areas'],
    );

    if (response is DataSuccess) {
      setState(() {
        subscribedAreas = response.data!;
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
    fetchSubscribedAreas();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surfaceTint,
          appBar: CustomAppBar(title: "Areas"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
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
                            color: Colors.black,
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
                      color: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      shadowColor: theme.colorScheme.shadow,
                      child: ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.add,
                            color: theme.colorScheme.tertiary,
                            size: 40,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 16.0, right: 32.0),
                          child: Text(
                            translate('createNewArea'),
                            style: TextStyle(
                              color: theme.colorScheme.tertiary,
                              fontFamily: 'IstokWeb',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreatePage()),
                          );
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
