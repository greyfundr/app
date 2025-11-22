import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = "https://api.greyfundr.com";


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
