import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_storage/models/api.dart';
import 'package:file_storage/models/user_information.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserInformation _user = API.user;

  Future<void> _launchUrl() async {
    var uri = Uri.parse(_user.resume as String);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          // card to display information
          child: Card(
            child: Column(
              children: [
                // image
                _user.profile == null || _user.profile == ""
                    ? const Text("No Profile Picture")
                    : SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(_user.profile as String),
                        ),
                      ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Name'),
                  subtitle: Text(
                      "${_user.username!.firstName} ${_user.username!.lastName}"),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone'),
                  subtitle: Text(_user.mobile as String),
                ),
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('National ID'),
                  subtitle: Text(_user.nationalId as String),
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Qualification'),
                  subtitle: Text(_user.qualification as String),
                ),
                ListTile(
                  leading: const Icon(Icons.approval),
                  title: const Text('Gender'),
                  subtitle: Text(_user.gender as String),
                ),
                ListTile(
                  leading: const Icon(Icons.watch),
                  title: const Text('Age'),
                  subtitle: Text(_user.age as String),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            _launchUrl();
                          },
                          child: const Text('View CV'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (result != null) {
                              PlatformFile temp = result.files.first;
                              if (temp.size > 250000) {
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'CV size must be less than 250kb'),
                                    ),
                                  );
                                  return;
                                });
                              } else {
                                await API.updateProfileResume(
                                    File(temp.path as String));
                                await API.getUser();
                                setState(() {
                                  _user = API.user;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('CV Updated'),
                                    ),
                                  );
                                  return;
                                });
                              }
                            }
                          },
                          child: const Text('Edit CV'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['png', 'jpg', 'jpeg'],
                            );
                            if (result != null) {
                              PlatformFile temp = result.files.first;

                              // temp size mjst be less than 250kb
                              if (temp.size > 250000) {
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Image size must be less than 250kb'),
                                    ),
                                  );
                                  return;
                                });
                              } else {
                                await API.updateProfileImage(
                                    File(temp.path as String));
                                await API.getUser();
                                setState(() {
                                  _user = API.user;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Image Updated'),
                                    ),
                                  );
                                  return;
                                });
                              }
                            }
                          },
                          child: const Text('Edit Profile Picture'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
