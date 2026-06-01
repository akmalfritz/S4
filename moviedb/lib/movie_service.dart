import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

class MovieService {
  static const String _apiKey = 'ae0a9643980b7b88db8fbe8490912c04';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<MovieModel>> _getRequest(Uri uri) async {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () =>
          throw Exception('Request timeout. Periksa koneksi internet kamu.'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> resultsJson = data['results'] ?? [];
      return resultsJson.map((json) => MovieModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('API Key tidak valid. Periksa kembali _apiKey di movie_service.dart.');
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit tercapai. Coba lagi nanti.');
    } else {
      throw Exception('Gagal memuat data. Status: ${response.statusCode}');
    }
  }

  Future<List<MovieModel>> fetchPopularMovies() async {
    final uri = Uri.parse(
      '$_baseUrl/movie/popular?api_key=$_apiKey&language=id-ID&page=1',
    );
    return _getRequest(uri);
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    if (query.trim().isEmpty) return fetchPopularMovies();
    final encoded = Uri.encodeComponent(query.trim());
    final uri = Uri.parse(
      '$_baseUrl/search/movie?api_key=$_apiKey&language=id-ID&query=$encoded&page=1',
    );
    return _getRequest(uri);
  }
}