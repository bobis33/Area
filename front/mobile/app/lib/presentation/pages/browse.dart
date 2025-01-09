import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '/data/models/data.dart';
import '/data/sources/request_service.dart';
import '/data/sources/storage_service.dart';
import '/presentation/providers/language.dart';
import 'profile.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  List<dynamic> areas = [];
  Map<String, String> userEmails = {};
  String userEmail = '';
  List<dynamic> allAreas = [];
  List<dynamic> filteredAreas = [];
  String newAction = '';
  String newReaction = '';
  String? errorMessage;
  bool showAreas = true;

  final StorageService _storageService = StorageService();
  final RequestService _requestService = const RequestService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllAreas();
    _searchController.addListener(_filterAreas);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAreas);
    _searchController.dispose();
    super.dispose();
  }

  void _filterAreas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredAreas = allAreas.where((area) {
        final action = area['action'].toLowerCase();
        final reaction = area['reaction'].toLowerCase();
        return action.contains(query) || reaction.contains(query);
      }).toList();
    });
  }

  Future<void> fetchAllAreas() async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final response = await _requestService.makeRequest<List<dynamic>>(
      endpoint: '/area/get/all',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) => json.decode(response.body)['areas'],
    );

    if (response is DataSuccess) {
      setState(() {
        allAreas = response.data!;
        filteredAreas = allAreas;
      });
    } else if (response is DataError) {
      setState(() {
        errorMessage = '${translate('fetchSubscribedAreasError')}: ${response.error}';
      });
    }
  }

  Future<void> subscribeToArea(String areaId) async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final response = await _requestService.makeRequest<bool>(
      endpoint: '/area/subscribe?area_id=$areaId',
      method: 'POST',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) => response.statusCode == 200,
    );

    if (response is DataSuccess) {
      fetchAllAreas();
    } else if (response is DataError) {
      setState(() {
        errorMessage = '${translate('subscribeToAreaError')}: ${response.data}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: Color(0xFF272727),
          appBar: AppBar(
            title: Text(
              'Shared AREAS',
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Padding (
                    padding: const EdgeInsets.only(top: 16.0),
                    child:
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name or service',
                          hintStyle: TextStyle(color: Colors.white54),
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
                          filled: true,
                          fillColor: Color(0xFF343434),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                  ),
                  SizedBox(height: 16),
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ] else ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredAreas.length,
                      itemBuilder: (context, index) {
                        final area = filteredAreas[index];


                        // Display shared areas
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
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

                                // Footer to show number of downloads and subscribe button
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF343434),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.download_rounded,
                                        color: Colors.white, size: 30),
                                      SizedBox(width: 10),
                                      Text(
                                      area['subscribed_users'].length.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'IstokWeb',
                                        fontSize: 18,
                                      ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                      icon: Icon(Icons.add, color: Colors.white, size: 30),
                                      onPressed: () {
                                        subscribeToArea(area['_id']);
                                      },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}