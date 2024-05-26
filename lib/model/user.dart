import 'dart:io';

class UserModel{
  String username;
  String? firstname;
  String? lastname;
  String? email;
  String? password;

  UserModel({
    required this.username,
    this.firstname,
    this.lastname,
    this.email,
    this.password
  });

  factory UserModel.fromJsonOneUser(Map<String, dynamic> json){
    return UserModel(
      username: json['username'],
      email: json['email'],
      firstname: json['first_name'],
      lastname: json['last_name'],
    );
  }
}