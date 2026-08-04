import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

/// Dominant color of the image at [url], or `null` when it cannot be determined.
///
/// `PaletteGeneratorMaster.fromImageProvider` aborts with a bare
/// `TimeoutException` after its 15s default and forwards any image-stream error.
/// Some callers start this future without ever attaching it to a `FutureBuilder`,
/// so a thrown error escapes as an unhandled zone error and is recorded as a
/// fatal crash. Every caller renders a fallback when this returns null, so
/// failures are swallowed here.
Future<Color?> getDominantColor(String? url) async {
  if (url == null || !url.startsWith('http')) return null;

  try {
    final palette = await PaletteGeneratorMaster.fromImageProvider(
      CachedNetworkImageProvider(url),
      maximumColorCount: 1,
    );

    return palette.dominantColor?.color;
  } catch (_) {
    return null;
  }
}
