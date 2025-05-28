import 'package:flutter/material.dart';
import 'package:responsi/model/film_model.dart';
import 'package:responsi/services/api_service.dart';
import 'package:responsi/pages/detail_page.dart';
import 'package:responsi/pages/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<FilmData>> _filmList;

  @override
  void initState() {
    super.initState();
    _filmList = FilmService.getFilms();
  }

  void _refresh() {
    setState(() {
      _filmList = FilmService.getFilms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F1),
      appBar: AppBar(
        title: const Text("Halo, [123220202]"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<FilmData>>(
        future: _filmList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("Tidak ada film."));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final film = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetailPage(id: film.id!)),
                        );
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: film.imgUrl != null && film.imgUrl!.isNotEmpty
                                  ? Image.network(
                                      film.imgUrl!,
                                      width: 80,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.movie, size: 60),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(film.title ?? "Tanpa Judul",
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text("${film.year ?? '-'}"),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 18),
                                      const SizedBox(width: 4),
                                      Text("${film.rating ?? '-'}"),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _actionButton("Edit", Colors.orange, () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditPage(film: film),
                                          ),
                                        ).then((_) => _refresh());
                                      }),
                                      const SizedBox(width: 8),
                                      _actionButton("Delete", Colors.red, () async {
                                        await FilmService.deleteFilm(film.id!);
                                        _refresh();
                                      }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create').then((_) => _refresh());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: color.withOpacity(0.2),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text),
    );
  }
}
