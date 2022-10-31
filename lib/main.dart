import 'package:flutter/material.dart';
import 'package:flutter_file_storage_challenge/home_screen.dart';
import 'package:flutter_file_storage_challenge/models/server.dart';
import 'package:flutter_file_storage_challenge/profile_screen.dart';

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
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: !isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : API.here
              ? const ProfilePage()
              : const HomeScreen(),
    );
  }
}
