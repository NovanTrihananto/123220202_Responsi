import 'package:flutter/material.dart';
import 'package:responsi/model/film_model.dart';
import 'package:responsi/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final int id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Film Detail")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _filmDetail(),
      ),
    );
  }

  Widget _filmDetail() {
    return FutureBuilder<FilmData>(
      future: FilmService.getFilmById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData) {
          return _filmWidget(snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _filmWidget(FilmData film) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Title: ${film.title ?? 'N/A'}", style: const TextStyle(fontSize: 18)),
          Text("Year: ${film.year ?? 'N/A'}"),
          Text("Rating: ${film.rating?.toStringAsFixed(1) ?? 'N/A'}"),
          Text("Genre: ${film.genre ?? 'N/A'}"),
          Text("Director: ${film.director ?? 'N/A'}"),
          const SizedBox(height: 12),
          film.imgUrl != null
              ? Image.network(film.imgUrl!)
              : const Text("No Image Available"),
          const SizedBox(height: 16),
          Text("Synopsis:\n${film.synopsis ?? '-'}"),
          const SizedBox(height: 16),
          if (film.movieUrl != null)
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(film.movieUrl!);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch ${film.movieUrl}';
                }
              },
              child: const Text("Visit Website"),
            ),
        ],
      ),
    );
  }
}
