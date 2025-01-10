import 'dart:convert';
import 'package:area_front_mobile/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '/data/models/data.dart';
import '/data/sources/storage_service.dart';
import '/data/sources/request_service.dart';
import '/presentation/providers/language.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? errorMessage;
  bool showAreas = true;

  final StorageService _storageService = StorageService();
  final RequestService _requestService = const RequestService();

  Future<void> createArea(String action, String reaction) async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final response = await _requestService.makeRequest<bool>(
      endpoint: '/area/create?action=$action&reaction=$reaction',
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

  @override
  void initState() {
    super.initState();
  }

  String action = '';
  String reaction = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: Color(0xFF272727),
          appBar: AppBar(
            title: Text(
              'Create AREA',
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
                    shadowColor: Colors.black,
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
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              action = value;
                            });
                          },
                          decoration: InputDecoration(
                          hintText: 'Enter action',
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'IstokWeb',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          ),
                          style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'IstokWeb',
                          ),
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
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              reaction = value;
                            });
                          },
                          decoration: InputDecoration(
                          hintText: 'Enter reaction',
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'IstokWeb',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          ),
                          style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'IstokWeb',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
            floatingActionButton: FloatingActionButton(
            onPressed: () {
              createArea(action, reaction);
            },
            backgroundColor: Color(0xFF0F4FC7),
            child: Icon(Icons.done, color: Colors.white),
            ),
        );
      },
    );
  }
}