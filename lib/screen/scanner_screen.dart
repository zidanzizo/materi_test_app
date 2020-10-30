import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/scanQR.dart';
import '../provider/auth.dart';

class ScannerScreen extends StatefulWidget {
  static const route_name = '/scanner';

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  int _userId;
  List<ScanQR> _scannedQR = [];
  var qrText = '';
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void initState() {
    getDataUser();
    super.initState();
  }

  void getDataUser() async {
    var _userProfile =
        await Provider.of<Auth>(context, listen: false).profile();
    _userId = _userProfile['id'];
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) async {
        if (qrText != scanData) {
          setState(() {
            qrText = scanData;
            _scannedQR.add(ScanQR(
              title: qrText,
              tanggal: DateTime.now(),
            ));
          });
          await Provider.of<Auth>(context, listen: false)
              .barcodeScan(_userId, qrText);
        }
      },
    );
  }

  String hourPick(DateTime dateTime) {
    String formattedDate = DateFormat.Hm().format(dateTime);
    return formattedDate;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7E7E7),
      appBar: AppBar(
        backgroundColor: Color(0xFF131E9E),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 28,
            ),
            onPressed: Navigator.of(context).pop),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            'ACTIVITY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'scanned: $qrText',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        dragStartBehavior: DragStartBehavior.down,
                        itemCount: _scannedQR.length,
                        itemBuilder: (context, index) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                _scannedQR[index].title,
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  hourPick(_scannedQR[index].tanggal),
                                  style: TextStyle(fontSize: 22),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.blue[900],
                                    ),
                                    color: Colors.greenAccent[700],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
