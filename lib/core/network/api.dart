import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

 class Network{
  final String _url = 'http://medrese.uk/api';
  final String baseUrl = 'http://medrese.uk';
  dynamic token;

  _getToken(String? accessToken) async {
    if(accessToken==null){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      token = localStorage.getString('token');
    }
    else
      {
        token=accessToken;
      }
  }
  // postAuthImages(apiUrl,Map <String,dynamic>?data,List <Asset> images)
  // async{
  //   var fullUrl = _url + apiUrl;
  //   await _getToken();
  //   List<MultipartFile> multipartImageList =[];
  //   for (Asset asset in images) {
  //     ByteData byteData = await asset.getByteData();
  //     List<int> imageData = byteData.buffer.asUint8List();
  //     MultipartFile multipartFile =  MultipartFile.fromBytes(
  //       imageData,
  //       filename: asset.name,
  //     );
  //     multipartImageList.add(multipartFile);
  //   }
  //   FormData formData = FormData.fromMap({
  //     "images[]": multipartImageList,
  //   });
  //   data==null?print("h"):formData.fields.addAll(FormData.fromMap(data).fields);
  //   Dio dio =  Dio();
  //   var response = await dio.post(fullUrl, data: formData,
  //       options: Options(
  //           validateStatus: (status) => true,
  //           headers:_setHeadersAuth()),
  //   );
  //   print(response.toString());
  //   return response.data;
  // }
  postAuthImage(apiUrl,data,File image,imageName,String apikeyImage,String? accessToken)
  async{
      var fullUrl = _url + apiUrl;
      await _getToken(accessToken);
      List<int> imageData = image.readAsBytesSync();
      MultipartFile multipartFile =  MultipartFile.fromBytes(
        imageData,
        filename: imageName,
      );
    FormData formData = FormData.fromMap({
      apikeyImage: multipartFile,
    });
      formData.fields.addAll(FormData.fromMap(data).fields);
      Dio dio =  Dio();
    var response = await dio.post(fullUrl, data: formData,
        options: Options(
            validateStatus: (status) => true,
            headers:_setHeadersAuth()),
    );
    return response.data;
  }
  postImage(apiUrl,data,File image,imageName,String apikeyImage)
  async{
      var fullUrl = _url + apiUrl;
      List<int> imageData = image.readAsBytesSync();
      MultipartFile multipartFile =  MultipartFile.fromBytes(
        imageData,
        filename: imageName,
      );
    FormData formData = FormData.fromMap({
      apikeyImage: multipartFile,
    });
      formData.fields.addAll(FormData.fromMap(data).fields);
      Dio dio =  Dio();
    var response = await dio.post(fullUrl, data: formData,
        options: Options(
            validateStatus: (status) => true,
        ),
    );
    return response.data;
  }
  postAuthData(data, apiUrl,String? accessToken) async {
    var fullUrl = _url + apiUrl;
    await _getToken(accessToken);
    final response= await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeadersAuth()
    );
    return jsonDecode(response.body);
  }
  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    var data1=  jsonEncode(data);
    final response= await http.post(
        Uri.parse(fullUrl),
        body:data1,
        headers: _setHeaders()
    );
    return jsonDecode(response.body);
  }

  getAuthData(apiUrl,String? accessToken) async {
    var fullUrl = _url + apiUrl;
    await _getToken(accessToken);
    final response= await http.get(
        Uri.parse(fullUrl),
        headers: _setHeadersAuth()
    );
    return jsonDecode(response.body);

  }
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    final response= await http.get(
        Uri.parse(fullUrl)
    );
    return jsonDecode(response.body);
  }

  _setHeadersAuth() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : 'Bearer $token'
  };
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json'
  };

}