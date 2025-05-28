class FilmModel {
  String? status;
  String? message;
  FilmData? data;

  FilmModel({this.status, this.message, this.data});

  FilmModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? FilmData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['status'] = status;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    return result;
  }
}

class FilmList {
  String? status;
  String? message;
  List<FilmData>? data;

  FilmList({this.status, this.message, this.data});

  FilmList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = List<FilmData>.from(json['data'].map((x) => FilmData.fromJson(x)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['status'] = status;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((x) => x.toJson()).toList();
    }
    return result;
  }
}

class FilmData {
  int? id;
  String? title;
  int? year;
  double? rating;
  String? imgUrl;
  String? genre;
  String? director;
  String? synopsis;
  String? movieUrl;

  FilmData({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.imgUrl,
    this.genre,
    this.director,
    this.synopsis,
    this.movieUrl,
  });

  FilmData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    rating = (json['rating'] is int) ? (json['rating'] as int).toDouble() : json['rating'];
    imgUrl = json['imgUrl'];
    genre = json['genre'];
    director = json['director'];
    synopsis = json['synopsis'];
    movieUrl = json['movieUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['year'] = year;
    data['rating'] = rating;
    data['imgUrl'] = imgUrl;
    data['genre'] = genre;
    data['director'] = director;
    data['synopsis'] = synopsis;
    data['movieUrl'] = movieUrl;
    return data;
  }
}
