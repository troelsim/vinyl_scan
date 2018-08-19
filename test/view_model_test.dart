import 'package:test/test.dart';
import 'package:redux/redux.dart';

import 'package:vinyl_scan/view_model.dart';
import 'package:vinyl_scan/models.dart';
import 'package:vinyl_scan/widgets/main_screen.dart';

Store<AppState> getStore(AppState state){
  return Store<AppState>((state,_) => state, initialState: state);
}

void main(){
  group("view model", (){
    group("view", (){
      test("is scanner by default", (){
        final store = getStore(AppState.initial());
        expect(AppViewModel.fromStore(store).view, MainScreenView.scanner);
      });

      test("is results if albumTitle is not null and loading is false", (){
        final store = getStore(AppState.initial().copyWith(albumTitle: "something"));
        expect(AppViewModel.fromStore(store).view, MainScreenView.results);
      });

      test("is notFound if notFound is true", (){
        final store = getStore(AppState.initial().copyWith(notFound: true));
        expect(AppViewModel.fromStore(store).view, MainScreenView.notFound);
      });

      test("is loading if loading is true", (){
        final store = getStore(AppState.initial().copyWith(loading: true));
        expect(AppViewModel.fromStore(store).view, MainScreenView.loading);
      });

      test("is loading if loading is true even if albumTitle is not null", (){
        final store = getStore(AppState.initial().copyWith(loading: true, albumTitle: "something"));
        expect(AppViewModel.fromStore(store).view, MainScreenView.loading);
      });
    });
  });
}
