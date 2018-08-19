import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

typedef OnDetectedCallback(String code);

class Scanner extends StatelessWidget{
  final OnDetectedCallback onDetected;

  Scanner({this.onDetected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: 400.0,
          height: 200.0,
          child: new QrCamera(
            qrCodeCallback: (code) {
              onDetected(code);
              print(code);
            },
          ),
        ),
        SizedBox(
          width: 400.0,
          height: 200.0,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white, width: 4.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  "Point to barcode",
                  style: TextStyle(color: Colors.white, fontSize: 24.0)
                )
              )
            ),
          ),
        ),
      ],
    );
  }
}
