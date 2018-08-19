import 'package:redux/redux.dart';
import 'models.dart';
import 'action_creators.dart';
import 'reducer.dart';
import 'widgets/main_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AppViewModel {
  final Store<AppState> _store;

  AppState get _state => _store.state;

  String get albumTitle => _state.albumTitle;

  MainScreenView get view {
    if (_state.loading) {
      return MainScreenView.loading;
    }
    if (_state.albumTitle != null) {
      return MainScreenView.results;
    }
    if (_state.notFound) {
      return MainScreenView.notFound;
    }
    return MainScreenView.scanner;
  }

  void onDetected(String barcode){
    print("in onDetected");
    if (!_store.state.loading){
      print("dispatching search");
      _store.dispatch(search(barcode));
    }
  }

  void onCancel(){
    _store.dispatch(Clear());
  }

  void launchSpotify() async {
    if (await canLaunch(_state.spotifyTitle)){
      await launch(_state.spotifyTitle);
    }
  }

  void launchYoutube(){

  }

  AppViewModel({store}) : _store = store;

  factory AppViewModel.fromStore(Store<AppState> store){
    return AppViewModel(
      store: store
    );
  }
}
