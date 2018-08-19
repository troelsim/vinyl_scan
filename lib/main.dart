import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:spotify/spotify_io.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'models.dart';
import 'reducer.dart';
import 'view_model.dart';
import 'widgets/main_screen.dart';

void main() {
  final store = Store<AppState>(appReducer, initialState: AppState.initial(), middleware: [thunkMiddleware]);
  runApp(new VinylScanner(store: store));
}

class VinylScanner extends StatelessWidget {
  final Store<AppState> store;

  VinylScanner({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinyl Scanner',
      theme: new ThemeData(
        primaryColor: Color(0xFF424242),
        accentColor: Color(0xFFFFA726),
      ),
      home: new Scaffold(
        appBar: AppBar(
          title: new Text('Vinyl Scanner'),
        ),
        body: StoreProvider<AppState>(
          store: store,
          child: StoreConnector<AppState, AppViewModel>(
            converter: (Store<AppState> store) => AppViewModel.fromStore(store),
            builder: (BuildContext context, AppViewModel vm) =>
              MainScreen(
                view: vm.view,
                albumTitle: vm.albumTitle,
                onDetected: vm.onDetected,
                onCancel: vm.onCancel,
                onSpotify: vm.launchSpotify,
                onYoutube: vm.launchYoutube,
              )
          )
        )
      ),
    );
  }
}
