import 'package:flutter/material.dart';
import 'package:responsi/model/film_model.dart';
import 'package:responsi/services/api_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _genreController = TextEditingController();
  final _directorController = TextEditingController();
  final _ratingController = TextEditingController();
  final _synopsisController = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final film = FilmData(
        title: _titleController.text,
        year: int.tryParse(_yearController.text),
        genre: _genreController.text,
        director: _directorController.text,
        rating: double.tryParse(_ratingController.text),
        synopsis: _synopsisController.text,
        imgUrl: "", // default kosong
        movieUrl: "", // default kosong
      );

      try {
        await FilmService.addFilm(film);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Film berhasil ditambahkan')));
        Navigator.pop(context); // Kembali ke HomePage
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
      appBar: AppBar(title: const Text('Tambah Film')),
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
                      child: const Text('Simpan'),
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
