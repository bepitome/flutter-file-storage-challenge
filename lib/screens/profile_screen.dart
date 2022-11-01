import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_storage_challenge/models/server.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_file_storage_challenge/models/person.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Person user = API.user;
  final imagePicker = ImagePicker();

  Future<void> _launchUrl() async {
    var uri = Uri.parse(user.resume as String);
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
                user.profile == null || user.profile == ""
                    ? const Text("No Profile Picture")
                    : SizedBox(
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(user.profile as String),
                        ),
                      ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Name'),
                  subtitle: Text(
                      "${user.username!.firstName} ${user.username!.lastName}"),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Phone'),
                  subtitle: Text(user.mobile as String),
                ),
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('National ID'),
                  subtitle: Text(user.nationalId as String),
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Qualification'),
                  subtitle: Text(user.qualification as String),
                ),
                ListTile(
                  leading: const Icon(Icons.approval),
                  title: const Text('Gender'),
                  subtitle: Text(user.gender as String),
                ),
                ListTile(
                  leading: const Icon(Icons.watch),
                  title: const Text('Age'),
                  subtitle: Text(user.age as String),
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
                                  user = API.user;
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
                            // ignore: deprecated_member_use
                            var pickedImage = await imagePicker.getImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedImage != null) {
                              File image = File(pickedImage.path);
                              int imageLength = await image.length();
                              if (imageLength > 250000) {
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
                                await API.updateProfileImage(image);
                                await API.getUser();
                                setState(() {
                                  user = API.user;
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
