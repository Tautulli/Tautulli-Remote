import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

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
    final result = await SimpleBarcodeScanner.scanBarcode(
      context,
      lineColor: '#${Theme.of(context).colorScheme.primary.toARGB32().toRadixString(16)}',
      cancelButtonText: 'CANCEL',
      isShowFlashIcon: false,
      scanFormat: ScanFormat.ONLY_QR_CODE,
    );

    if (result == '-1' || result == null) return null;

    final List scanResults = result.split('|');
    if (scanResults.length < 2) return null;
    final connectionAddress = scanResults[0].trim();
    final deviceToken = scanResults[1].trim();

    return Tuple2(connectionAddress, deviceToken);
  }
}
