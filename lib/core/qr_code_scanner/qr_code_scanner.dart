import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

abstract class QrCodeScanner {
  /// Scan with the camera until a barcode is identified, then return a `Tuple2`
  /// with the connection address and device token.
  ///
  /// Returns `null` when canceled.
  Future<Tuple2<String, String>?> scan(BuildContext context);
}

class QrCodeScannerImpl implements QrCodeScanner {
  @override
  Future<Tuple2<String, String>?> scan(BuildContext context) async {
    final result = await FlutterBarcodeScanner.scanBarcode(
      '#${Theme.of(context).colorScheme.primary.value.toRadixString(16)}',
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
