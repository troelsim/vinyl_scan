import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/spotify_io.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'mock_store.dart';

import 'package:vinyl_scan/action_creators.dart';
import 'package:vinyl_scan/reducer.dart';
import 'package:vinyl_scan/discogs.dart';

class MockSpotifyApi extends Mock implements SpotifyApi {}
class MockAlbums extends Mock implements Albums {}

class MockDiscogsClient extends Mock implements DiscogsClient {}

void main(){
  test("findAlbumTitle dispatches StartedSearching and GotAlbumTitle", () async {
    final mockStore = MockStore(middleware: [thunkMiddleware]);
    final client = MockDiscogsClient();

    when(client.albumName("abcd")).thenAnswer(
      (_) async => "Sjakket - Bange & Forvirret"
    );

    await findAlbumTitle("abcd", client: client)(mockStore);
    await mockStore.wait();

    expect(mockStore.actions[0], isInstanceOf<StartedSearching>());
    expect(mockStore.actions[1], isInstanceOf<GotAlbumTitle>());
    expect(mockStore.actions[1].albumTitle, "Sjakket - Bange & Forvirret");
  });

  test("findAlbumTitle dispatches NotFound if exception is thrown", () async {
    final mockStore = MockStore(middleware: [thunkMiddleware]);
    final client = MockDiscogsClient();

    when(client.albumName("abcd")).thenThrow("Not Found");

    await findAlbumTitle("abcd", client: client)(mockStore);
    await mockStore.wait();

    expect(mockStore.actions[0], isInstanceOf<StartedSearching>());
    expect(mockStore.actions[1], isInstanceOf<NotFound>());
  });

  test("findSpotifyTitle dispatches ReceivedSpotifyResult", () async {
    final mockStore = MockStore(middleware: [thunkMiddleware]);
    final client = MockSpotifyApi();
    final albums = MockAlbums();

    when(client.albums).thenReturn(albums);

    when(albums.search("Sjakket - Bange & Forvirret")).thenAnswer(
      (_) async => <Album>[
        Album(uri: 'sjakket-bf')
      ]
    );
    await findSpotifyTitle("Sjakket - Bange & Forvirret", client: client)(mockStore);
    await mockStore.wait();
    expect(mockStore.actions[0], isInstanceOf<ReceivedSpotifyResult>());
    expect(mockStore.actions[0].spotifyTitle, "sjakket-bf");
  });

  test("findSpotifyTitle dispatches ReceivedSpotifyResult with null data", () async {
    final mockStore = MockStore(middleware: [thunkMiddleware]);
    final client = MockSpotifyApi();
    final albums = MockAlbums();

    when(client.albums).thenReturn(albums);

    when(albums.search("Sjakket - Bange & Forvirret")).thenAnswer(
      (_) async => <Album>[]
    );
    await findSpotifyTitle("Sjakket - Bange & Forvirret", client: client)(mockStore);
    await mockStore.wait();
    expect(mockStore.actions[0], isInstanceOf<ReceivedSpotifyResult>());
    expect(mockStore.actions[0].spotifyTitle, null);
  });
}
