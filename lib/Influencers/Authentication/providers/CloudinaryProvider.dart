import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CloudinaryProvider with ChangeNotifier {
  final String cloudName =
      "dhwuxvadl"; // Replace with your Cloudinary cloud name
  final String uploadPreset =
      "eawmdcc9"; // Replace with your unsigned upload preset

  Future<String?> uploadImage(File imageFile, {String? folder}) async {
    try {
      final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      // Create form data
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['upload_preset'] = uploadPreset;

      if (folder != null) {
        request.fields['folder'] = folder;
      }

      // Add file to request
      var pic = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(pic);

      // Send request
      var response = await request.send();

      // Check status
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = String.fromCharCodes(responseData);
        var jsonData = jsonDecode(result);
        return jsonData['secure_url'];
      } else {
        print('Error uploading to Cloudinary: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception during Cloudinary upload: $e');
      return null;
    }
  }
}
