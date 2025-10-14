import 'dart:convert';

import 'package:news_app/models/news_response.dart';
import 'package:news_app/utils/constants.dart';
import 'package:http/http.dart' as http;
// mendefinisikan sebuah package/library menjadi sebuah variable GET

class NewsServices {
  static const String _baseUrl = Constants.baseURL;
  static final String _apiKey = Constants.apiKey;

// fungsi yang bertujuan untuk membuat request get ke serve
  Future<NewsResponse> getTopHeadlines({
    String country = Constants.defaultCountry,
    String? category,
    int page = 1,
    int pageSize = 20
  }) async {
    try { 
      final Map<String, String>queryParams = {
        'apiKey':_apiKey,
        'country':country,
        'page':page.toString(),
        'pageSize':pageSize.toString()
      };

     // statement yang dijalankan ketika category tidak kosong
      if (category !=null && category.isNotEmpty) {
        queryParams['category']= category;
      }

    // berfungsi untuk parsing data dari json ke UI
    // simplenya: kita daftarin baseURL + endpoint yang akan di gunakan 
      final uri=Uri.parse('$_baseUrl${Constants.topHeadlines  }')
            .replace(queryParameters: queryParams);
        // untuk menyinpam respon yang di berikan oleh serve
        final response = await http.get(uri);  

  // kode yang akan dijalankan jika request ke API sukses
    if (response.statusCode == 200) {
      // untuk merubah data dari json ke bahsa dart
        final jsonData = json.decode(response.body);
        return NewsResponse.fromJson(jsonData);
        // kode yang dijalankan jika request ke API gagal (status HTTP != 200)
      } else {
        throw Exception('Failed to load news, please try again later');
      }
      // kode yang akan dijalankan ketika ada error lain, selain error yang diatas
    } catch (e) {
      throw Exception('Another problem occurs, please try agaian later');
    }
  }

  Future<NewsResponse> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
    String? sortBy,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'apiKey': _apiKey,
        'q': query,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final uri = Uri.parse('$_baseUrl${Constants.everything}')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to search news, please try again later');
      }
    } catch (e) {
      throw Exception('Another problem occurs, please try again later');
    }
  }
}