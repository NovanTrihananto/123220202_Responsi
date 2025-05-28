import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi/model/film_model.dart';

class FilmService {
  static const url =
      'https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1/movies';

  static Future<List<Film>> getFilms() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> filmList = jsonData['data']; // akses list film
      return filmList
          .map((e) => Film.fromJson(e))
          .toList(); // konversi ke List<FilmData>
    } else {
      throw Exception('Failed to load films');
    }
  }

  // GET film by ID
  static Future<Film> getFilmById(int id) async {
    final response = await http.get(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Film.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load film');
    }
  }

  // POST film baru
  static Future<Map<String,dynamic>> post(Film film) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(film.toJson()),
    );
        return jsonDecode(response.body);
  }

  // PUT update film
  static Future<Map<String, dynamic>> updateFilm(Film updateFilm) async {
  final response = await http.patch(
    Uri.parse("$url/${updateFilm.id}"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updateFilm.toJson()), // <- fix di sini
  );
    return jsonDecode(response.body);
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
