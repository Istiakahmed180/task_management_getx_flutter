class ProfileDetailsModel {
  String? status;
  List<ProfileData>? data;

  ProfileDetailsModel({this.status, this.data});

  ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ProfileData>[];
      json['data'].forEach((v) {
        data!.add(ProfileData.fromJson(v));
      });
    }
  }
}

class ProfileData {
  String? sId;
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? password;
  String? photo;
  String? createdDate;

  ProfileData(
      {this.sId,
      this.email,
      this.firstName,
      this.lastName,
      this.mobile,
      this.password,
      this.photo,
      this.createdDate});

  ProfileData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    password = json['password'];
    photo = json['photo'];
    createdDate = json['createdDate'];
  }
}
