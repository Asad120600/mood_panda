import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebViewSignIn extends StatefulWidget {
  final String apiUrl;

  WebViewSignIn({required this.apiUrl});

  @override
  _WebViewSignInState createState() => _WebViewSignInState();
}

class _WebViewSignInState extends State<WebViewSignIn> {
  late WebViewController _controller;
  String? googleAuthUrl; // Store the extracted Google URL

  @override
  void initState() {
    super.initState();
    _fetchGoogleSignInUrl(); // Fetch correct Google URL before loading WebView
  }

  Future<void> _fetchGoogleSignInUrl() async {
    try {
      final response = await http.get(Uri.parse(widget.apiUrl));

      if (response.statusCode == 200) {
        // Extract the actual Google OAuth URL from API response
        final Map<String, dynamic> responseData =
            jsonDecode(response.body); // ✅ Corrected JSON parsing
        setState(() {
          googleAuthUrl =
              responseData['url']; // ✅ Directly extract 'url' from the object
        });
      } else {
        print(
            "Failed to fetch Google Sign-In URL. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching Google Sign-In URL: $e");
    }
  }

  Future<void> _handleAuthRedirect(String url) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Uri uri = Uri.parse(url);

      // Extract token or necessary data from the redirected URL (assuming query parameters)
      String? token = uri.queryParameters['token'];
      String? userId = uri.queryParameters['user_id'];
      String? role = uri.queryParameters['role'];
      String? userName = uri.queryParameters['name'];

      if (token != null) {
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId ?? '');
        await prefs.setString('role', role ?? '');
        await prefs.setString('user_name', userName ?? '');
      }

      Navigator.pop(context); // Close WebView after successful login
    } catch (e) {
      print("Error processing auth response: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Sign-In")),
      body: googleAuthUrl == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading while fetching URL
          : WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url.contains("callback")) {
                        _handleAuthRedirect(request.url);
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(
                    googleAuthUrl!)), // ✅ Correctly loading extracted URL
            ),
    );
  }
}
