
class MovieMovieDB {
    final bool adult;
    final String backdropPath;
    final List<int> genreIds;
    final int id;
    final String originalLanguage;
    final String originalTitle;
    final String overview;
    final double popularity;
    final String posterPath;
    final DateTime? releaseDate;
    final String title;
    final bool video;
    final double voteAverage;
    final int voteCount;

    MovieMovieDB({
        required this.adult,
        required this.backdropPath,
        required this.genreIds,
        required this.id,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        required this.posterPath,
        required this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    factory MovieMovieDB.fromJson(Map<String, dynamic> json) =>  MovieMovieDB(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"] ?? '',
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"] ?? '',
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"] ?? '',
        releaseDate: (json["release_date"] != null && json["release_date"] != "")? DateTime.parse(json["release_date"]) : null,
        //releaseDate: _parseDate(json["release_date"]),
        //releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
    );

    // static DateTime _parseDate(String? dateString) {
    //   if (dateString == null || dateString.isEmpty) {
    //     // Manejar fecha por defecto si es nula o vacía
    //     return DateTime(1970, 1, 1); // Puedes ajustar esto según tus necesidades
    //   }
    //   try 
    //     {
    //       return DateTime.parse(dateString);
    //     } catch (e) {
    //       print('Error parsing date: $dateString');
    //       // Manejar fecha por defecto en caso de error de parseo
    //       return DateTime(1970, 1, 1); // Puedes ajustar esto según tus necesidades
    //     }
    // }

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate != null ? "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}" : null,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}
