// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vinyl_scan/widgets/main_screen.dart';
import 'package:vinyl_scan/widgets/scanner.dart';
import 'package:vinyl_scan/widgets/results.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

Widget wrap(Widget child){
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group("Main Screen widget", (){
    testWidgets('Main widget renders scanner by default', (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MainScreen(view: MainScreenView.scanner)));
      expect(find.byType(Scanner), findsOneWidget);
    });

    testWidgets("renders Spinner if loading", (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MainScreen(view: MainScreenView.loading)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("renders Not Found message if notFound", (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MainScreen(view: MainScreenView.notFound)));
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets("renders results", (WidgetTester tester) async {
      await tester.pumpWidget(wrap(MainScreen(view: MainScreenView.results)));
      expect(find.byType(Results), findsOneWidget);
    });
  });

  group("Scanner widget", (){
    testWidgets("renders QrCamera and some text", (WidgetTester tester) async {
      await tester.pumpWidget(wrap(Scanner()));
      expect(find.byType(QrCamera), findsOneWidget);
      expect(find.text("Point to barcode"), findsOneWidget);
    });
  });

  group("Results widget", (){
    testWidgets("given a spotify result, renders spotify button", (WidgetTester tester) async {
      await tester.pumpWidget(wrap(Results(spotifyTitle: "Sjakket - Bange & Forvirret")));
      expect(find.text("Sjakket - Bange & Forvirret"), findsOneWidget);
    });

    testWidgets("given no spotify result, renders 'not found'", (WidgetTester tester) async {
      await tester.pumpWidget(wrap(Results()));
      expect(find.text("Not found"), findsOneWidget);
    });

    testWidgets("renders youtube button", (WidgetTester tester) async{
      await tester.pumpWidget(wrap(Results()));
      expect(find.text("Search YouTube"), findsOneWidget);
    });

    testWidgets("renders cancel button", (WidgetTester tester) async{
      await tester.pumpWidget(wrap(Results()));
      expect(find.text("Scan again"), findsOneWidget);
    });

    testWidgets("spotify button calls spotify callback", (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrap(Results(
        spotifyTitle: "Sjakket - Bange & Forvirret",
        spotifyCallback: () { tapped = true; }
      )));
      await tester.tap(find.text("Sjakket - Bange & Forvirret"));
      await tester.pump();
      expect(tapped, true);
    });

    testWidgets("youtube button calls youtube callback", (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrap(Results(
        youtubeCallback: () { tapped = true; }
      )));
      await tester.tap(find.text("Search YouTube"));
      await tester.pump();
      expect(tapped, true);
    });

    testWidgets("cancel button calls cancel callback", (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(wrap(Results(
        cancelCallback: () { tapped = true; }
      )));
      await tester.tap(find.text("Cancel"));
      await tester.pump();
      expect(tapped, true);
    });
  });
}
