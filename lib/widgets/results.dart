import "package:flutter/material.dart";

typedef void OnCancelCallback();
typedef void OnSpotifyCallback();
typedef void OnYoutubeCallback();

class Results extends StatelessWidget {
  final String spotifyTitle;
  final OnSpotifyCallback spotifyCallback;
  final OnYoutubeCallback youtubeCallback;
  final OnCancelCallback cancelCallback;

  Results({
    Key key, this.spotifyTitle,
    this.spotifyCallback,
    this.youtubeCallback,
    this.cancelCallback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //fit: BoxFit.cover,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            color: Color(0xFF1DB954),
            onPressed: () => this.spotifyCallback(),
            child: this.spotifyTitle != null ?
             Text(this.spotifyTitle)
             :
             Text("Not found")
          ),
          RaisedButton(
            color: Color(0xFFCC181E),
            child: Text("Search YouTube"),
            onPressed: () => this.youtubeCallback()
          ),
          FlatButton(
            child: Text("Scan again"),
            onPressed: () => this.cancelCallback()
          ),
        ]
      )
    );
  }

}
