import 'package:file_storage/models/api.dart';
import 'package:file_storage/screens/display_profile.dart';
import 'package:file_storage/screens/form_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  Future checkPhysicalID() async {
    await API.getUser();
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    checkPhysicalID();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: !isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : API.isExist
              ? const Profile()
              : const FormPage(),
    );
  }
}
