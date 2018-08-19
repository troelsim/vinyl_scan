class AppState {
  final bool loading;
  final bool notFound;
  final String barcode;
  final String albumTitle;
  final String spotifyTitle;

  AppState({
    this.loading, this.barcode, this.albumTitle, this.spotifyTitle, this.notFound
  });

  factory AppState.from(AppState other){
    return AppState(
      loading: other.loading,
      notFound: other.notFound,
      barcode: other.barcode,
      albumTitle: other.albumTitle,
      spotifyTitle: other.spotifyTitle
    );
  }

  AppState copyWith({
    bool loading,
    bool notFound,
    String barcode,
    String albumTitle,
    String spotifyTitle
  }){
    return AppState(
      loading: loading ?? this.loading,
      notFound: notFound ?? this.notFound,
      barcode: barcode ?? this.barcode,
      albumTitle: albumTitle ?? this.albumTitle,
      spotifyTitle: spotifyTitle ?? this.spotifyTitle
    );
  }

  factory AppState.initial(){
    return AppState(
      loading: false,
      notFound: false,
      barcode: null,
      albumTitle: null,
      spotifyTitle: null
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
        loading == other.loading &&
        notFound == other.notFound &&
        barcode == other.barcode &&
        albumTitle == other.albumTitle &&
        spotifyTitle == other.spotifyTitle;

  @override
  int get hashCode =>
    loading.hashCode ^
    notFound.hashCode ^
    barcode.hashCode ^
    albumTitle.hashCode ^
    spotifyTitle.hashCode;
}
