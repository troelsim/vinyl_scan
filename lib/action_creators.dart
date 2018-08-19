import 'package:spotify/spotify_io.dart';
import 'package:redux/redux.dart';
import 'reducer.dart';
import 'discogs.dart';
import 'models.dart';

Function findAlbumTitle(String barcode, {DiscogsClient client}) {
  print("In findAlbumTitle outer");
  return (Store store) async {
    print("In findAlbumTitle inner");
    store.dispatch(StartedSearching());
    client = client != null ? client : DiscogsClient();
    try {
      final title = await client.albumName(barcode);
      store.dispatch(GotAlbumTitle(albumTitle: title));
    }catch (e){
      store.dispatch(NotFound());
    }
  };
}

Function findSpotifyTitle(String title, {SpotifyApi client}) {
  return (Store store) async {
    print("in findSpotifyTitle inner");
    final credentials = new SpotifyApiCredentials(
      "539dea7a0f914d7791afd4330ddd50cc",
      "83e24188a23041e69fbe77af1c721f0d"
    );
    client = client != null ? client : SpotifyApi(credentials);

    print("Querying spotify API");
    final results = await client.albums.search(title);
    print("Got results");
    if (results.length > 0){
      store.dispatch(ReceivedSpotifyResult(spotifyTitle: results.first.uri));
    }
    store.dispatch(ReceivedSpotifyResult(spotifyTitle: null));
    print("exiting findSpotifyTitle");
  };
}

Function search(String barcode, {DiscogsClient client, SpotifyApi spotifyClient}){
  print("in search outer");
  return (Store<AppState> store) async {
    print("in search inner");
    await findAlbumTitle(barcode, client: client)(store);
    await findSpotifyTitle(store.state.albumTitle, client: spotifyClient)(store);
  };
}
