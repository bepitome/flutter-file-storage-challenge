import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_file_storage_challenge/models/person.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: depend_on_referenced_packages
import "package:http_parser/http_parser.dart";

class API {
  static const String baseUrl = 'http://143.244.145.16/api/v1/user';
  static String physicalID = '';
  static bool here = false;
  static List<String> qualifications = [];
  static Person user = Person();
  static Future getQualifications() async {
    var url = Uri.parse('$baseUrl/qualifications');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'multipart/form-data; boundary=123',
        'Accept': '*/*',
        'x-physical-id': physicalID,
      },
    );
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data = data["result"]["data"]["qualifications"] as List;

        return data;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future getPhysicalID() async {
    var device = DeviceInfoPlugin();

    var iosInfo = await device.iosInfo;
    if (Platform.isIOS) {
      API.physicalID = iosInfo.identifierForVendor as String;
    }
  }

  static Future createProfile(String data, File? image, File? pdf) async {
    var url = Uri.parse("$baseUrl/create");
    var request = http.MultipartRequest('PUT', url);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data;',
      'Accept': '*/*',
      'x-physical-id': physicalID,
    });

    request.fields.addAll(
      {
        "data": data,
      },
    );

    if (pdf != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          pdf.path,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    }
    if (image != null) {
      String filetype = image.path.split("/").last.split(".").last;
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          image.path,
          contentType: MediaType('image', filetype),
        ),
      );
    }

    var response = await request.send();
    var jsonResponse = await response.stream.toBytes();
    var jsonResponseDecoded = jsonDecode(utf8.decode(jsonResponse));
    if (jsonResponseDecoded["result"]["code"] == 201) {
      return;
    }
  }

  static Future updateProfileImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/update-image"),
    );
    request.headers.addAll({
      'Content-Type': 'multipart/form-data;',
      'Accept': '*/*',
      'x-physical-id': physicalID,
    });

    String filetype = image.path.split("/").last.split(".").last;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: MediaType('image', filetype),
      ),
    );

    var response = await request.send();
    var jsonResponse = await response.stream.toBytes();
    var jsonResponseDecoded = jsonDecode(utf8.decode(jsonResponse));
    if (jsonResponseDecoded['result']['code'] == 200) {
      return;
    }
  }

  static Future updateProfileResume(File resume) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/update-resume"),
    );
    request.headers.addAll({
      'Content-Type': 'multipart/form-data;',
      'Accept': '*/*',
      'x-physical-id': physicalID,
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        resume.path,
        contentType: MediaType('application', "pdf"),
      ),
    );

    var response = await request.send();
    var jsonResponse = await response.stream.toBytes();
    var jsonResponseDecoded = jsonDecode(utf8.decode(jsonResponse));
    if (jsonResponseDecoded['result']['code'] == 200) {
      return;
    }
  }

  static Future getUser() async {
    await getPhysicalID();
    var response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'x-physical-id': physicalID,
      },
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse["result"]["code"] == 200) {
      here = true;
      var result = jsonResponse['result']["data"];
      user = Person.fromJson(result);
      return;
    } else {
      here = false;
      return null;
    }
  }
}
