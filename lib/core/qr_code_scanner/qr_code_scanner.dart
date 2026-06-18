import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global_keys/global_keys.dart';
import '../types/app_style.dart';
import 'qr_scanner_page.dart';

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
    final result = await navigatorKey.currentState?.push<String>(
      currentAppStyle == AppStyle.cupertino
          ? CupertinoPageRoute<String>(builder: (_) => const QrScannerPage())
          : MaterialPageRoute<String>(builder: (_) => const QrScannerPage()),
    );

    if (result == null) return null;

    final scanResults = result.split('|');
    if (scanResults.length < 2) return null;

    return Tuple2(scanResults[0].trim(), scanResults[1].trim());
  }
}
