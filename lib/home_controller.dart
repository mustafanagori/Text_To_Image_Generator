import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ImageController extends GetxController {
  final _imageData = <Uint8List>[].obs;
  final _isProcessing = false.obs;

  List<Uint8List> get imageData => _imageData;
  bool get isProcessing => _isProcessing.value;
  TextEditingController promptController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();

  Future<void> textToImage() async {
    _isProcessing.value = true;
    final url = Uri.parse(
        "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'sk-rjcDqk21fk74cypuU7mzjE08LxQPXIWO3EbmSNFSwkuE8YHt',
    };

    final body = {
      'steps': 40,

      // 'width': 1024,
      // 'height': 1024,
      'seed': 0,
      'cfg_scale': 5,
      'samples': 4,
      'text_prompts': [
        {'text': promptController.text.toString(), 'weight': 1},
        //{'text': '', 'weight': -1},
      ],
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseJSON = jsonDecode(response.body);
        _imageData.clear();

        for (final image in responseJSON['artifacts']) {
          final Uint8List imageData = base64Decode(image['base64']);
          _imageData.add(imageData);
        }

        promptController.clear();
      } else {
        throw Exception('Non-200 response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during the request: $e');
    } finally {
      _isProcessing.value = false;
    }
  }
}
