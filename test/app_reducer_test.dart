import 'package:test/test.dart';
import 'package:vinyl_scan/reducer.dart';
import 'package:vinyl_scan/models.dart';

class SomeAction{}

void main(){
  group("App reducer", (){
    test("returns same state as default", (){
      final state = AppState();
      expect(appReducer(state, SomeAction()), state);
    });

    test("DetectedBarcode sets barcode", (){
      final state = AppState.initial();
      expect(appReducer(state, DetectedBarcode(barcode: "1234")).barcode, "1234");
    });

    test("GotAlbumTitle sets album titl", (){
      final state = AppState.initial();
      expect(
        appReducer(state, GotAlbumTitle(albumTitle: "Sjakket - Bange & Forvirret")),
        state.copyWith(albumTitle: "Sjakket - Bange & Forvirret")
      );
    });

    test("ReceivedSpotifyResult sets spotify result title and unsets loading", (){
      final state = AppState.initial().copyWith(loading: true);
      expect(
        appReducer(state, ReceivedSpotifyResult(spotifyTitle: "Sjakket, bange & forvirret")),
        state.copyWith(spotifyTitle: "Sjakket, bange & forvirret", loading: false)
      );
    });

    test("NotFound sets notFound and unsets loading", (){
      final state = AppState.initial().copyWith(loading: true);
      expect(
        appReducer(state, NotFound()),
        state.copyWith(notFound: true, loading: false)
      );
    });

    test("Clear resets app state", (){
      final state = AppState(
        loading: true,
        barcode: "hej",
        spotifyTitle: "Lol",
        albumTitle: "far"
      );
      expect(
        appReducer(state, Clear()),
        AppState.initial()
      );
    });

    test("StartedSearching sets loading", (){
      final state = AppState.initial();
      expect(appReducer(state, StartedSearching()), state.copyWith(loading: true));
    });
  });
}
