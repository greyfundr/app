import 'dart:core';
import '../class/campaign.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = "https://greyfoundr-backend.onrender.com";


  Future <dynamic>  getCategory() async {
    Map<String, dynamic>? category;
    try {
      final response = await _dio.get(
        "$baseUrl/campaign/getCategory",
      );

      if (response.statusCode == 200) {
        dynamic category = response.data["campaign"];
        print(category);
        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }

  Future <dynamic>  getCampaignApproval(String id) async {
    Map<String, dynamic>? category;
    final String url = '$baseUrl/posts/$id';
    try {
      final response = await _dio.get(
        '$baseUrl/campaign/getApprovalStatus/$id');

      if (response.statusCode == 200) {
        dynamic category = response.data["campaign"];

        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }

  Future <dynamic>  getUserNotification(String id) async {
    Map<String, dynamic>? category;
    final String url = '$baseUrl/posts/$id';
    try {
      final response = await _dio.get(
          '$baseUrl/notifications/notifications/$id');

      if (response.statusCode == 200) {
        dynamic category = response.data;

        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }

  Future <dynamic>  getCampaign() async {
    List <Campaign>? category;
    try {
      final response = await _dio.get(
        "$baseUrl/campaign/getall",
      );

      if (response.statusCode == 200) {

        dynamic category = response.data[0];
        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }

  Future <dynamic>  approveStakeholderCampaign(String id, String campaignId) async {
    Map<String, dynamic>? category;
    final String url = '$baseUrl/posts/$id';
    try {
      final response = await _dio.get(
          '$baseUrl/campaign/getApprovalStatus/$id');

      if (response.statusCode == 200) {
        dynamic category = response.data["campaign"];

        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }

  Future <dynamic>  getUsers() async {
    Map<String, dynamic>? users;
    try {
      final response = await _dio.get(
        "$baseUrl/users",
      );

      if (response.statusCode == 200) {
        dynamic users = response.data[0];
        //print(users);

        return users;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return users;
  }




  Future<bool> login(String email, String password) async {
    SharedPreferences.setMockInitialValues({});
    try {
      final response = await _dio.post(
        "$baseUrl/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        String token = response.data["token"];
        await saveToken(token);
        return true;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return false;
  }

  Future<void> saveToken(String token) async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwt_token", token);

  }

  Future<String?> getToken() async {

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
  }
}