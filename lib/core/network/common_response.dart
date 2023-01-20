import 'package:flutter/foundation.dart';

class CommonResponse<T> {
  late int statusCode;
  late bool status;
  T? data;
  Map<dynamic, dynamic>? error;

  CommonResponse.fromJson(dynamic json) {
    try {
      status = json["status"];
      if (status) {
        json["data"]!=null?data = json["data"]:print("kaka");
      } else {
        error = json["error"];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  bool get getStatus {
    return status;
  }

  T? get getData {
    return data;
  }

  Map<dynamic, dynamic>? get getError {
    return error;
  }
}
