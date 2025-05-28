import 'package:flutter/material.dart';
import 'package:responsi/model/film_model.dart';
import 'package:responsi/services/api_service.dart';

class EditPage extends StatefulWidget {
  final FilmData film;

  const EditPage({super.key, required this.film});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _yearController;
  late TextEditingController _genreController;
  late TextEditingController _directorController;
  late TextEditingController _ratingController;
  late TextEditingController _synopsisController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.film.title);
    _yearController = TextEditingController(text: widget.film.year?.toString());
    _genreController = TextEditingController(text: widget.film.genre);
    _directorController = TextEditingController(text: widget.film.director);
    _ratingController = TextEditingController(text: widget.film.rating?.toString());
    _synopsisController = TextEditingController(text: widget.film.synopsis);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updatedFilm = FilmData(
        id: widget.film.id,
        title: _titleController.text,
        year: int.tryParse(_yearController.text),
        genre: _genreController.text,
        director: _directorController.text,
        rating: double.tryParse(_ratingController.text),
        synopsis: _synopsisController.text,
        imgUrl: widget.film.imgUrl ?? "", // tetap pakai yang lama
        movieUrl: widget.film.movieUrl ?? "", // tetap pakai yang lama
      );

      try {
        await FilmService.updateFilm(updatedFilm);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Film berhasil diperbarui')));
        Navigator.pop(context); // kembali ke HomePage
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    _directorController.dispose();
    _ratingController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Film')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_titleController, "Judul"),
              _buildTextField(_yearController, "Tahun", keyboardType: TextInputType.number),
              _buildTextField(_genreController, "Genre"),
              _buildTextField(_directorController, "Direktur"),
              _buildTextField(_ratingController, "Rating", keyboardType: TextInputType.number),
              _buildTextField(_synopsisController, "Sinopsis", maxLines: 3),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Simpan Perubahan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }
}
