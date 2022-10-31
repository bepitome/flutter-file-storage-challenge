import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class API {
  // =================== API ===================
  static const String BASE_URL = 'http://143.244.145.16/api/v1/';
  static const String CREATE_USER = BASE_URL + 'user/create';
  static const String GET_USER = BASE_URL + 'user/profile';
  static const String GET_QUALIFICATION = BASE_URL + 'user/qualifications';
  static const String UPDATE_PROFILE_IMAGE = BASE_URL + 'user/update-image';
  static const String UPDATE_PROFILE_RESUME = BASE_URL + '/user/update-resume';

  static String physicalID = "";

  // =================== Methods ===================
  // Get Qualifications
  static Future<List<String>> getQualifications() async {
    await getPhysicalID();
    var response = await http.get(
      Uri.parse(GET_QUALIFICATION),
      headers: {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'x-physical-id': physicalID,
      },
    );
    List<String> dropdownItems = [];
    var jsonResponse = jsonDecode(response.body);
    var result = jsonResponse['result']["data"]["qualifications"];
    for (var i = 0; i < result.length; i++) {
      dropdownItems.add(result[i]["name"]);
    }

    return dropdownItems;
  }

  static Future getPhysicalID() async {
    var device = DeviceInfoPlugin();

    var androidInfo = await device.androidInfo;
    if (Platform.isAndroid) {
      API.physicalID = androidInfo.id;
    }
  }

  static Future createProfile(String data, File image, File resume) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(CREATE_USER),
    );
    request.headers.addAll({
      'Content-Type': 'multipart/form-data; boundary=123',
      'Accept': '*/*',
      'x-physical-id': "7577.252992.3232.32322",
    });

    request.fields.addAll(
      {
        "data": data,
      },
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'files',
        image.path,
      ),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'files',
        resume.path,
      ),
    );

    var response = await request.send();
    var jsonReponse = await response.stream.toBytes();
    var jsonResponseDecoded = jsonDecode(utf8.decode(jsonReponse));
    print(response.statusCode);
    print(response.reasonPhrase);
    print(jsonResponseDecoded);
  }

  static Future updateProfileImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(UPDATE_PROFILE_IMAGE),
    );
    request.headers.addAll({
      'Content-Type': 'multipart/form-data;',
      'Accept': '/',
      'x-physical-id': "22222.32222.3232.32322",
    });

    var imageLength = await image.length();
    request.files.add(
      http.MultipartFile(
        "image",
        image.readAsBytes().asStream(),
        imageLength,
      ),
    );

    var response = await request.send();
    var jsonReponse = await response.stream.toBytes();
    var jsonResponseDecoded = jsonDecode(utf8.decode(jsonReponse));
    print(response.statusCode);
    print(response.reasonPhrase);
    print(jsonResponseDecoded);
  }

  static Future updateProfileResume(File resume) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(UPDATE_PROFILE_RESUME),
    );
    request.headers.addAll({
      'Content-Type': 'multipart/form-data;',
      'Accept': '/',
      'x-physical-id': "22222.322222.3232.32322",
    });

    var resumeLength = await resume.length();
    request.files.add(
      http.MultipartFile(
        "cv",
        resume.readAsBytes().asStream(),
        resumeLength,
      ),
    );

    var response = await request.send();
    var jsonReponse = await response.stream.toBytes();
    var jsonResponseDecoded = jsonDecode(utf8.decode(jsonReponse));
    print(response.statusCode);
    print(response.reasonPhrase);
    print(jsonResponseDecoded);
  }

  static Future getUser() async {
    await getPhysicalID();
    var response = await http.get(
      Uri.parse(GET_USER),
      headers: {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'x-physical-id': physicalID,
      },
    );
    var jsonResponse = jsonDecode(response.body);
    var result = jsonResponse['result']["data"];
    return result;
  }
}
