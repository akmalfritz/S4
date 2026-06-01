class MovieModel {
  int? id;
  String? title;
  String? overview;
  String? posterPath;
  String? backdropPath;
  String? releaseDate;
  double? voteAverage;
  int? voteCount;
  List<int>? genreIds;

  MovieModel({
    this.id,
    this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.genreIds,
  });

  MovieModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    backdropPath = json['backdrop_path'];
    releaseDate = json['release_date'];
    voteAverage = (json['vote_average'] as num?)?.toDouble();
    voteCount = json['vote_count'];
    genreIds = json['genre_ids'] != null
        ? List<int>.from(json['genre_ids'])
        : [];
  }

  String get releaseYear {
    if (releaseDate == null || releaseDate!.isEmpty) return 'N/A';
    return releaseDate!.split('-').first;
  }

  String get ratingFormatted {
    if (voteAverage == null) return 'N/A';
    return voteAverage!.toStringAsFixed(1);
  }
}