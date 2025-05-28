import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi/model/film_model.dart';

class FilmService {
  static const url =
      'https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1/film';

  static Future<List<FilmData>> getFilms() async {
    // Mengirim GET request ke url, kemudian disimpan ke dalam variabel "response"
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  // GET film by ID
  static Future<FilmData> getFilmById(int id) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return FilmData.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load film');
    }
  }

  // POST film baru
  static Future<FilmModel> addFilm(FilmData film) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(film.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return FilmModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add film');
    }
  }

  // PUT update film
  static Future<FilmModel> updateFilm(FilmData film) async {
    if (film.id == null) throw Exception("Film ID is required for update.");

    final response = await http.put(
      Uri.parse('$url/${film.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(film.toJson()),
    );

    if (response.statusCode == 200) {
      return FilmModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update film');
    }
  }

  // DELETE film
  static Future<FilmModel> deleteFilm(int id) async {
    final response = await http.delete(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      return FilmModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete film');
    }
  }
}
