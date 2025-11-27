import 'dart:convert';
import 'dart:core';
import 'dart:io';
import '../class/campaign.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // Required for MediaType
import 'package:mime/mime.dart';


class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = "https://api.greyfundr.com";

  Future<dynamic> getCategory() async {
    Map<String, dynamic>? category;
    try {
      final response = await _dio.get("$baseUrl/campaign/getCategory");

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

  Future<dynamic> getCampaignApproval(String id) async {
    Map<String, dynamic>? category;
    try {
      final response = await _dio.get(
        '$baseUrl/campaign/getApprovalStatus/$id',
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

  Future<dynamic> getUserNotification(String id) async {
    Map<String, dynamic>? category;
    final String url = '$baseUrl/posts/$id';
    try {
      final response = await _dio.get(
        '$baseUrl/notifications/notifications/$id',
      );

      if (response.statusCode == 200) {
        dynamic category = response.data;

        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }

  Future<dynamic> createCampaign(Campaign campaign, int id) async {
    List<MultipartFile> multipartImages = [];
    Response response;

    Dio dio = Dio();
    try {
      for (File imageFile in campaign.images) {
        String fileName = imageFile.path.split('/').last;
        String? mimeType = lookupMimeType(fileName);
        print(fileName);

        multipartImages.add(
          await MultipartFile.fromFile(
            imageFile.path,
            filename: fileName,
            contentType: MediaType(
              mimeType!.split('/')[0],
              mimeType.split('/')[1],
            ), // Adjust content type as needed
          ),
        );
      }
      print(campaign.startDate);
      print(campaign.endDate);
      FormData formData = FormData.fromMap({
        "image": multipartImages,
        'title': campaign.title,
        'description': campaign.description,
        'category': campaign.category,
        'startDate': campaign.startDate,
        'endDate': campaign.endDate,
        'amount': campaign.amount.toString(),
        'id': id,
        'stakeholders': json.encode(campaign.participants),
        'images': campaign.imageUrl!.path,
      });

      Response response = await dio.post(
        "$baseUrl/campaign/create",
        data: formData,
      );
      return response;
      print("Image uploaded successfully: ${response.data}");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<dynamic> updateUser(users) async {
    dynamic user = users;
    print(users);
    File profile = File(user['profile_pic']);
    Response response;
    print(users);
    Dio dio = Dio();
    try {

      String fileName = profile.path.split('/').last;
      String? mimeType = lookupMimeType(fileName);
      print(fileName);






      FormData formData = FormData.fromMap({
        "image":  await MultipartFile.fromFile(
          profile.path,
          filename: fileName,
          contentType: MediaType(
            mimeType!.split('/')[0],
            mimeType.split('/')[1],
          ), // Adjust content type as needed
        ),
        'id': user['id'],
        'first_name': user['first_name'],
        'last_name': user['last_name'],
        'username': user['username'],

      });
      int id = user['id'];
      print(id);
      Response response = await dio.post(
        "$baseUrl/users/updateUser/$id",
        data: formData,
      );
      return response;
      print("Image uploaded successfully: ${response.data}");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<dynamic> getCampaign() async {
    List<Campaign>? category;
    try {
      final response = await _dio.get("$baseUrl/campaign/getall");

      if (response.statusCode == 200) {
        dynamic category = response.data[0];
        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }

  Future<dynamic> sendOtp(int phoneNumber) async {
    List<Campaign>? category;
    try {
      final response = await _dio.get("$baseUrl/campaign/getall");

      if (response.statusCode == 200) {
        dynamic category = response.data[0];
        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }


  Future<dynamic> approveStakeholderCampaign(
      String id,
      String campaignId,
      ) async {
    Map<String, dynamic>? category;
    final String url = '$baseUrl/posts/$id';
    try {
      final response = await _dio.get(
        '$baseUrl/campaign/getApprovalStatus/$id',
      );

      if (response.statusCode == 200) {
        dynamic category = response.data["campaign"];

        return category;
      }
    } catch (e) {
      print("Login failed: $e");
    }
    return category;
  }

  Future<dynamic> getUsers() async {
    Map<String, dynamic>? users;
    try {
      final response = await _dio.get("$baseUrl/users");

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

  Future<dynamic> getChampions() async {
    Map<String, dynamic>? users;
    try {
      final response = await _dio.get("$baseUrl/champion");

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

  Future<dynamic> getBackers() async {
    Map<String, dynamic>? users;
    final token = await getToken();
    print(token);

    try {
      final response = await _dio.get("$baseUrl/backer",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
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
        "$baseUrl/auth/login",
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

  Future<bool> createDonation(int userId, int creatorId, int campaignId, int amount) async {
    print(userId);
    print(creatorId);
    print(campaignId);
    print(amount);
    try {
      final response = await _dio.post(
        "$baseUrl/donor/createDonor",
        data: {
          "amount" :amount,
          "creator_id" : creatorId,
          "user_id" : userId,
          "campaign_id" : campaignId},
      );

      if (response.statusCode == 200) {
        String token = response.data["msg"];

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
