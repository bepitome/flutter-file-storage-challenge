class UserInformation {
  Username? username;
  String? sId;
  String? physicalId;
  String? nationalId;
  String? email;
  String? gender;
  String? age;
  String? mobile;
  String? qualification;
  String? profile;
  String? resume;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserInformation(
      {this.username,
      this.sId,
      this.physicalId,
      this.nationalId,
      this.email,
      this.gender,
      this.age,
      this.mobile,
      this.qualification,
      this.profile,
      this.resume,
      this.createdAt,
      this.updatedAt,
      this.iV});

  UserInformation.fromJson(Map<String, dynamic> json) {
    username =
        json['username'] != null ? Username.fromJson(json['username']) : null;
    sId = json['_id'];
    physicalId = json['physical_id'];
    nationalId = json['national_id'];
    email = json['email'];
    gender = json['gender'];
    age = json['age'];
    mobile = json['mobile'];
    qualification = json['qualification'];
    profile = json['profile'];
    resume = json['resume'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (username != null) {
      data['username'] = username!.toJson();
    }
    data['_id'] = sId;
    data['physical_id'] = physicalId;
    data['national_id'] = nationalId;
    data['email'] = email;
    data['gender'] = gender;
    data['age'] = age;
    data['mobile'] = mobile;
    data['qualification'] = qualification;
    data['profile'] = profile;
    data['resume'] = resume;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Username {
  String? firstName;
  String? lastName;
  String? sId;

  Username({this.firstName, this.lastName, this.sId});

  Username.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['_id'] = sId;
    return data;
  }
}
