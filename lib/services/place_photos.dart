import 'package:flutter/material.dart';

class PlacePhotoAPI {
  static String getPhotoUri(String? ref) {
    if (ref == null) return "http://via.placeholder.com/1920x1080";

    Map<String, dynamic>? params = {'maxheight': '1080', 'photo_reference': ref, 'key': 'AIzaSyBmobQB7cfd7KvpQpPo8vyumWAIz9bBRFI'};

    String out = Uri.https('maps.googleapis.com', '/maps/api/place/photo', params).toString();
    // debugPrint(out);
    return out;
  }
}
