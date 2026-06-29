import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../translations/locale_keys.g.dart';
import '../types/app_style.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  bool _hasResult = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_hasResult) return;
    final value = capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (value == null) return;

    _hasResult = true;

    if (value.split('|').length == 2) {
      if (mounted) Navigator.of(context).pop(value);
      return;
    }

    if (!mounted) return;

    final appStyle = (context.read<SettingsBloc>().state as SettingsSuccess).appSettings.appStyle;

    if (appStyle == AppStyle.cupertino) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(LocaleKeys.qr_code_unsupported_dialog_title.tr()),
          content: Text(value),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.dismiss_title.tr()),
            ),
          ],
        ),
      );
    } else {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(LocaleKeys.qr_code_unsupported_dialog_title.tr()),
          content: Text(value),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.dismiss_title.tr()),
            ),
          ],
        ),
      );
    }

    _hasResult = false;
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    final appStyle = (context.read<SettingsBloc>().state as SettingsSuccess).appSettings.appStyle;
    final isCupertino = appStyle == AppStyle.cupertino;

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -80)),
      width: 240,
      height: 240,
    );

    final cornerColor = isCupertino ? CupertinoTheme.of(context).primaryColor : Theme.of(context).colorScheme.primary;

    return ColoredBox(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            scanWindow: scanWindow,
            onDetect: _onDetect,
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (!value.isInitialized || !value.isRunning || value.error != null) {
                return const SizedBox();
              }
              return CustomPaint(painter: _ScanWindowPainter(scanWindow, cornerColor));
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  state as SettingsSuccess;

                  Widget button = state.appSettings.appStyle == AppStyle.cupertino
                      ? CupertinoButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            LocaleKeys.cancel_title.tr(),
                            style: const TextStyle(color: CupertinoColors.white, fontSize: 18),
                          ),
                        )
                      : TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            LocaleKeys.cancel_title.tr(),
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        );

                  if (state.appSettings.disableImageBackgrounds) {
                    button = DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                      child: button,
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: button,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanWindowPainter extends CustomPainter {
  const _ScanWindowPainter(this.scanWindow, this.cornerColor);

  final Rect scanWindow;
  final Color cornerColor;

  static const _bracketLen = 24.0;
  static const _bracketWidth = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(4))),
      ),
      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 0.5)
        ..style = PaintingStyle.fill,
    );

    final bracketPaint = Paint()
      ..color = cornerColor
      ..strokeWidth = _bracketWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final l = scanWindow.left;
    final t = scanWindow.top;
    final r = scanWindow.right;
    final b = scanWindow.bottom;

    // Top-left
    canvas.drawLine(Offset(l, t + _bracketLen), Offset(l, t), bracketPaint);
    canvas.drawLine(Offset(l, t), Offset(l + _bracketLen, t), bracketPaint);
    // Top-right
    canvas.drawLine(Offset(r - _bracketLen, t), Offset(r, t), bracketPaint);
    canvas.drawLine(Offset(r, t), Offset(r, t + _bracketLen), bracketPaint);
    // Bottom-left
    canvas.drawLine(Offset(l, b - _bracketLen), Offset(l, b), bracketPaint);
    canvas.drawLine(Offset(l, b), Offset(l + _bracketLen, b), bracketPaint);
    // Bottom-right
    canvas.drawLine(Offset(r - _bracketLen, b), Offset(r, b), bracketPaint);
    canvas.drawLine(Offset(r, b), Offset(r, b - _bracketLen), bracketPaint);
  }

  @override
  bool shouldRepaint(_ScanWindowPainter oldDelegate) =>
      oldDelegate.scanWindow != scanWindow || oldDelegate.cornerColor != cornerColor;
}
