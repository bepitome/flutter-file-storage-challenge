import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_storage/models/user_information.dart';
import 'package:http/http.dart' as http;
import "package:http_parser/http_parser.dart";

class API {
  // =================== API ===================
  static const String baseURL = 'http://143.244.145.16/api/v1/';
  static const String createUser = '${baseURL}user/create';
  static const String getUserUrl = '${baseURL}user/profile';
  static const String getQualificationUrl = '${baseURL}user/qualifications';
  static const String updateProfileImageUrl = '${baseURL}user/update-image';
  static const String updateProfileResumeUrl = '${baseURL}user/update-resume';
  static bool isExist = false;
  static String physicalID = "";
  static UserInformation user = UserInformation();

  // =================== Methods ===================
  // Get Qualifications
  static Future<List<String>> getQualifications() async {
    await getPhysicalID();
    var response = await http.get(
      Uri.parse(getQualificationUrl),
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
      API.physicalID = "123.55.55.123"; //androidInfo.id;
    }
  }

  static Future createProfile(String data, File? image, File? resume) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(createUser),
    );
    request.headers.addAll({
      'Content-Type': 'multipart/form-data; boundary=123',
      'Accept': '*/*',
      'x-physical-id': physicalID,
    });

    request.fields.addAll(
      {
        "data": data,
      },
    );
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
    if (resume != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          resume.path,
        ),
      );
    }

    var response = await request.send();
    var jsonResponse = await response.stream.toBytes();
    var jsonResponseDecoded = jsonDecode(utf8.decode(jsonResponse));
    print(response.statusCode);
    print(response.reasonPhrase);
    print(jsonResponseDecoded);
  }

  static Future updateProfileImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(updateProfileImageUrl),
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
    print(response.statusCode);
    print(response.reasonPhrase);
    print(jsonResponseDecoded);
  }

  static Future updateProfileResume(File resume) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(updateProfileResumeUrl),
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
    print(response.statusCode);
    print(response.reasonPhrase);
    print(jsonResponseDecoded);
  }

  static Future getUser() async {
    await getPhysicalID();
    var response = await http.get(
      Uri.parse(getUserUrl),
      headers: {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'x-physical-id': physicalID,
      },
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse["result"]["code"] == 200) {
      isExist = true;
      var result = jsonResponse['result']["data"];
      user = UserInformation.fromJson(result);
      print(user.username!.firstName);
      return;
    } else {
      isExist = false;
      return null;
    }
  }
}
