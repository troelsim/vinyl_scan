import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models.dart';
import 'results.dart';
import 'scanner.dart';

enum MainScreenView { loading, scanner, results, notFound }

class MainScreen extends StatelessWidget{
  final MainScreenView view;
  final OnDetectedCallback onDetected;
  final OnCancelCallback onCancel;
  final OnSpotifyCallback onSpotify;
  final OnYoutubeCallback onYoutube;

  final String albumTitle;

  MainScreen({
    this.view, this.onDetected, this.onCancel, this.onSpotify, this.onYoutube,
    this.albumTitle
  });

  @override
  Widget build(BuildContext context) {
    switch(view){
      case MainScreenView.loading:
        return Center(
          child: FittedBox(
            fit: BoxFit.fill,
            child:CircularProgressIndicator()
          )
        );
      case MainScreenView.results:
        return Results(
          spotifyTitle: albumTitle,
          youtubeCallback: onYoutube,
          spotifyCallback: onSpotify,
          cancelCallback: onCancel,
        );
      case MainScreenView.notFound:
        return AlertDialog(
          title: Text("Not Found"),
          content: Text("Not Found"),
          actions: <Widget>[
            FlatButton(
              child: Text("Try again"),
              onPressed: onCancel
            )
          ]
        );
      default:
        return Scanner(onDetected: onDetected);
    }
  }
}
