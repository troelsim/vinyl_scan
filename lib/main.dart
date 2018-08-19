import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:spotify/spotify_io.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'discogs.dart';
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Vinyl Scanner',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        //primarySwatch: Colors.blue,
        primaryColor: Color(0xFF424242),
        accentColor: Color(0xFFFFA726),
      ),
      home: new MyHomePage(title: 'Vinyl Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool loading = false;
  bool noBarcodeResults = false;
  bool noAlbumResults = false;
  String albumTitle = "";

  void _resetState(){
    setState((){
      loading = false;
      noBarcodeResults = false;
      noAlbumResults = false;
    });
  }

  void _startProcessing(){
    setState((){
      loading = true;
    });
  }

  void _foundAlbumTitle(String albumTitle){
    setState((){
      this.albumTitle = albumTitle;
    });
  }

  void _foundSpotifyAlbum(){
    setState((){
      this.loading = false;
    });
  }

  void _barcodeLookupFailed(){
    setState((){
      this.loading = false;
      this.noBarcodeResults = true;
    });
  }

  void _spotifyLookupFailed(){
    setState((){
      this.loading = false;
      this.noAlbumResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Tap the button, then point your camera to the UPC barcode on a record",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0)
              )
            ),
            Text(
              this.loading ? "Searching..." :
              ( this.noBarcodeResults ? "No result for bar code" :
                (this.noAlbumResults ? "Album not found" : "")
              )
            ),
            (this.loading ? CircularProgressIndicator()
              : FittedBox(fit: BoxFit.contain, child: RaisedButton(
                color: Theme.of(context).accentColor ,
              onPressed: () async {
                await SimplePermissions.requestPermission(Permission.Camera);
                this._resetState();
                this.setState(() { loading = true; });
                String barcode = await BarcodeScanner.scan();
                print("Barcode: $barcode");
                String title;
                try{
                  title = await DiscogsClient().albumName(barcode);
                }catch (e){
                  print("No results on bar code");
                  this.setState((){
                    noBarcodeResults = true;
                    loading = false;
                  });
                  return null;
                }

                print("Album title: $title");

                final credentials = new SpotifyApiCredentials(
                  "539dea7a0f914d7791afd4330ddd50cc",
                  "83e24188a23041e69fbe77af1c721f0d"
                );
                final spotify = SpotifyApi(credentials);
                final results = await spotify.albums.search(title);

                if (results.length == 0){
                  noAlbumResults = true;
                    loading = false;
                  print("No results on album title");
                  return null;
                }

                final Album album = results.first;
                print(album.uri);
                _resetState();
                final youtubeUrl = "youtube://YouTube.com/results?search_query=${Uri.encodeComponent(title)}";
                //final youtubeUrl = "youtube://YouTube.com/results?search_query=sjakket";
                print("Can we launch $youtubeUrl?");
                if (await canLaunch(youtubeUrl)){
                  print("Yes");
                  launch(youtubeUrl);
                  this.setState((){
                    loading = false;
                  });
                  return null;
                }else{
                  print("No");
                  return null;
                }
                this.setState((){
                  loading = false;
                });
                if (await canLaunch(album.uri)){
                  await launch(album.uri);
                  Future.delayed(Duration(seconds: 5))
                    .then((dynamic){ setState((){ loading = false; }); });
                }else{
                  print("Can't launch url");
                  this.setState((){
                    loading = false;
                  });
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.camera_alt, size: 48.0),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Scan barcode", style: TextStyle(fontSize: 24.0))
                  )
                ]
              ),
            ))),
            //Scanner()
          ],
        ),
      ),
    );
  }
}
