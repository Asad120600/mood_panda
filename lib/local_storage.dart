import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Class to manage SharedPreferences globally
class LocalStorage {
  // Save data to SharedPreferences (handling both String and int types)
  static Future<void> saveData(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else {
      throw ArgumentError('Unsupported value type');
    }
  }

  // Get data from SharedPreferences (returns String or int based on the type)
  static Future<dynamic> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      if (prefs.get(key) is String) {
        return prefs.getString(key);
      } else if (prefs.get(key) is int) {
        return prefs.getInt(key);
      }
    }
    return null;
  }

  // Check if the user is logged in by checking the 'auth_token'
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    return authToken != null;
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('user_name'); // Fetch the username from SharedPreferences
  }

  // Clear all stored preferences (e.g., logout)
  static Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveRiderId(String riderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('rider_id', riderId);
  }

  static Future<String?> getRiderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('rider_id');
  }

  static Future<void> saveRiderAuth(String authtoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', authtoken);
  }

  static Future<String?> getRiderauth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> login(String email, String password) async {
    final url = 'https://moodpandaa.com/public/api/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        // Extract and save the relevant details from the response
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);
        await prefs.setInt('user_id', data['user_id']); // Save user_id
        await prefs.setString('user_name', data['name']); // Save username
        await prefs.setString(
            'store_name', data['store_name']); // Save store name
        await prefs.setString('role', data['role']); // Save role if required
        await prefs.setString('email', data['email']); // Save email
        await prefs.setString('phone', data['phone']); // Save phone number

        return true; // Login successful
      } else {
        return false; // Login failed (invalid credentials)
      }
    } else {
      return false; // Login failed (network or server issue)
    }
  }

  static Future<String?> getVendorAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user is a vendor
    String? role = prefs.getString('role');
    if (role != null && role.toLowerCase() == 'vendor') {
      // If the role is vendor, return the vendor's auth token
      return prefs.getString('auth_token');
    }
    return null; // Return null if the role is not vendor
  }

  static Future<int?> getVendorIdIfRoleIsVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check the role stored in SharedPreferences
    String? role = prefs.getString('role');
    if (role != null && role.toLowerCase() == 'vendor') {
      // Return the vendor_id if role matches "vendor"
      int? vendorId = prefs.getInt('user_id');

      // If vendorId is null, try retrieving it as a String and converting it to int
      if (vendorId == null) {
        String? vendorIdString = prefs.getString('user_id');
        if (vendorIdString != null) {
          vendorId = int.tryParse(vendorIdString);
        }
      }

      return vendorId; // Return the valid vendorId
    }

    return null; // Return null if role is not Vendor
  }

  // Method to get the authentication token
  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

// Method to save vendor_id (user_id) as an int
  static Future<void> saveVendorId(int vendorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', vendorId); // Save as int
  }

  // Method to get vendor_id as an int (if saved as int in SharedPreferences)
  static Future<int?> getVendorId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // First try getting the 'user_id' as int
    int? vendorId = prefs.getInt('user_id');

    // If it's null, try to fetch it as String and convert to int
    if (vendorId == null) {
      String? vendorIdString = prefs.getString('user_id');
      if (vendorIdString != null) {
        vendorId =
            int.tryParse(vendorIdString); // Convert string to int if possible
      }
    }
    return vendorId;
  }

  // Method to get vendor_id as String (if saved as string in SharedPreferences)
  static Future<String?> getVendorIdAsString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id'); // Fetch as String
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
