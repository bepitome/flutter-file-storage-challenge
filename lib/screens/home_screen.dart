import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_storage_challenge/models/server.dart';
import 'package:flutter_file_storage_challenge/screens/profile_screen.dart';

import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  String dropDownValue = '1';
  File? image;
  FilePicker? file;
  File? pdf;
  final imagePicker = ImagePicker();

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile temp = result.files.first;
      setState(() {
        pdf = File(temp.path as String);
      });
    }
  }

  var items = ["select qualification"];
  Future getDropMenu() async {
    // need to remove one
    // var data = await API.getQualifications();
    var qualifications = await API.getQualifications();
    List<String> temp = [];
    for (var i in qualifications) {
      if (i["name"] != '') {
        temp.add(i["name"]);
      }
    }
    setState(() {
      items = temp;
    });
  }

  Future uploadImage() async {
    // ignore: deprecated_member_use
    var pickedImage = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  List gender = ["Male", "Female", "N/D"];
  String genderValue = "";
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: genderValue,
          onChanged: (value) {
            setState(() {
              genderValue = value;
            });
          },
        ),
        Text(title),
      ],
    );
  }

  // List of items in our dropdown menu
  @override
  void initState() {
    super.initState();
    getDropMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('File Storage'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your First name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: 'Last Name',
                ),
              ),
              TextFormField(
                controller: nationalIdController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.badge),
                  labelText: 'National ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your national ID';
                  } else if (value.length != 10) {
                    return 'Please enter a valid national ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
                  }
                  // Use regex to validate email
                  else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.watch),
                  labelText: 'Age',
                ),
              ),
              TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Mobile Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Mobile Number';
                  } else if (value.length != 10) {
                    return 'Please enter a valid Mobile Number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your qualification';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.school),
                  labelText: 'Qualification',
                ),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    dropDownValue = value.toString();
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  addRadioButton(0, "Male"),
                  addRadioButton(1, "Female"),
                  addRadioButton(2, "N/D"),
                ],
              ),
              ElevatedButton(
                onPressed: uploadImage,
                child: const Text('Upload Image'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Upload CV'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (genderValue == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please Select Gender'),
                      ),
                    );
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    String data =
                        """{"national_id": "${nationalIdController.text}",
                        "username": {"first_name": "${firstNameController.text}" ,"last_name": "${lastNameController.text}"},
                        "email": "${emailController.text}",
                        "gender": "$genderValue",
                        "age": "${ageController.text}",
                        "mobile": "${mobileController.text}",
                        "qualification": "$dropDownValue"
                        }""";
                    data = data.replaceAll("\n", "");
                    data = data.replaceAll("  ", "");
                    await API.createProfile(
                        data,
                        image == null ? null : image as File,
                        pdf == null ? null : pdf as File);
                    await API.getUser();
                    setState(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    });
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ));
  }
}
