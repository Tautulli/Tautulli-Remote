import 'package:dartz/dartz.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

abstract class QrCodeScanner {
  /// Scan with the camera until a barcode is identified, then return a `Tuple2`
  /// with the connection address and device token.
  ///
  /// Returns `null` when canceled.
  Future<Tuple2<String, String>?> scan();
}

class QrCodeScannerImpl implements QrCodeScanner {
  @override
  Future<Tuple2<String, String>?> scan() async {
    final result = await FlutterBarcodeScanner.scanBarcode(
      '#e5a00d',
      'CANCEL',
      false,
      ScanMode.QR,
    );

    if (result == '-1') return null;

    final List scanResults = result.split('|');
    final connectionAddress = scanResults[0].trim();
    final deviceToken = scanResults[1].trim();

    return Tuple2(connectionAddress, deviceToken);
  }
}
