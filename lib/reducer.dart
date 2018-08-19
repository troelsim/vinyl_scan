import 'models.dart';

class DetectedBarcode{
  final String barcode;
  DetectedBarcode({this.barcode});
}

class GotAlbumTitle{
  final String albumTitle;
  GotAlbumTitle({this.albumTitle});
}

class ReceivedSpotifyResult{
  final String spotifyTitle;
  ReceivedSpotifyResult({this.spotifyTitle});
}

class NotFound{ }

class StartedSearching { }

class Clear{}

AppState appReducer(AppState state, action){
  if (action is DetectedBarcode){
    return state.copyWith(barcode: action.barcode);
  }

  if (action is GotAlbumTitle){
    return state.copyWith(
      albumTitle: action.albumTitle
    );
  }

  if (action is ReceivedSpotifyResult){
    return state.copyWith(
      spotifyTitle: action.spotifyTitle,
      loading: false
    );
  }

  if (action is NotFound){
    return state.copyWith(notFound: true, loading: false);
  }

  if (action is Clear){
    return AppState.initial();
  }

  if (action is StartedSearching){
    return state.copyWith(loading: true);
  }

  return state;
}
