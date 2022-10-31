import 'dart:io';

import 'package:file_storage/screens/display_profile.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../models/api.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nationalIDController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  String dropdownValue = "";
  File? profileImage;
  File? resume;

  List gender = ["male", "female", "N/D"];
  String select = "";

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title),
      ],
    );
  }

  List<String> dropdownItems = ["Loading..."];

  void fillQualifications() async {
    var tim = await API.getQualifications();
    setState(() {
      dropdownItems = tim;
    });
  }

  @override
  void initState() {
    super.initState();
    fillQualifications();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nationalIDController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registration'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
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
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Last Name',
                  ),
                ),
                TextFormField(
                  controller: _nationalIDController,
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
                  controller: _emailController,
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
                  controller: _ageController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.watch),
                    labelText: 'Age',
                  ),
                ),
                TextFormField(
                  controller: _mobileNumberController,
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

                // Radio buttons selector Male or Female
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.school),
                    labelText: 'Qualification',
                  ),
                  items: dropdownItems.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value.toString();
                    });
                  },
                ),
                Row(
                  children: <Widget>[
                    addRadioButton(0, 'Male'),
                    addRadioButton(1, 'Female'),
                    addRadioButton(2, 'N/D'),
                  ],
                ),

                // Drop down Menu For Qualification

                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      PlatformFile temp = result.files.first;
                      setState(() {
                        resume = File(temp.path as String);
                      });
                      print(temp.name);
                      print(temp.bytes);
                      print(temp.size);
                      print(temp.extension);
                      print(temp.path);
                    }
                  },
                  child: const Text('Upload CV'),
                ),
                resume == null
                    ? const Text("Upload CV")
                    : Text(resume.toString()),
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg', 'jpeg'],
                    );
                    if (result != null) {
                      PlatformFile temp = result.files.first;
                      setState(() {
                        profileImage = File(temp.path as String);
                      });
                      print(temp.name);
                      print(temp.bytes);
                      print(temp.size);
                      print(temp.extension);
                      print(temp.path);
                    }
                  },
                  child: const Text('Upload Profile Image'),
                ),
                profileImage == null
                    ? const Text("Upload Image")
                    : SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.file(profileImage!),
                      ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (select == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please Select Gender'),
                          ),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      String data =
                          """{"national_id": "${_nationalIDController.text}",
                        "username": {"first_name": "${_firstNameController.text}" ,"last_name": "${_lastNameController.text}"},
                        "email": "${_emailController.text}",
                        "gender": "$select",
                        "age": "${_ageController.text}",
                        "mobile": "${_mobileNumberController.text}",
                        "qualification": "$dropdownValue"
                        }""";
                      data = data.replaceAll("\n", "");
                      data = data.replaceAll("  ", "");
                      await API.createProfile(
                          data,
                          profileImage == null ? null : profileImage as File,
                          resume == null ? null : resume as File);
                      await API.getUser();
                      setState(() {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Profile(),
                          ),
                        );
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
