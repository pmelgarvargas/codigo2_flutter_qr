import 'dart:io';

import 'package:codigo2_qr/ui/general/colors.dart';
import 'package:codigo2_qr/ui/pages/register_page.dart';
import 'package:codigo2_qr/ui/widgets/button_normal_widget.dart';
import 'package:codigo2_qr/ui/widgets/general_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool isUrl = false;
  String valueUrl = "";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  //
  bool checkURL(String value) {
    bool res = value.contains("http");
    return res;
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: kBrandPrimaryColor,
        borderRadius: 14,
        borderLength: 26,
        borderWidth: 7,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          valueUrl = result!.code!;
          isUrl = checkURL(valueUrl);
        }
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: kBrandSecondaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isUrl ? valueUrl : "Por favor, escanea un código QR.",
                    //"https://www.youtube.com/watch?v=XQ45gynAUPg&ab_channel=AbbaVEVO https://www.youtube.com/watch?v=XQ45gynAUPg&ab_channel=AbbaVEVO",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  divider14,
                  ButtonNormalWidget(
                    text: "Registrar QR",
                    onPressed: !isUrl
                        ? () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(
                                  valueQR: "https://github.com/juliuscanute/qr_code_scanner/issues/560",
                                  //valueQR: valueUrl,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
