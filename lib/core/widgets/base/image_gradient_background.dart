import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

// =============================================================================
// ImageGradientBackground
// =============================================================================
// Disclosure: Produced with heavy involvement from Claude Code.
//
// OVERVIEW
// --------
// Produces a blurred, image-derived gradient background. The image is divided
// into a 3x3 grid of nine regions. The most prominent color from each region
// becomes the color anchor for that cell. The center row may use
// the most vivid color instead when the top and bottom rows are both dark. A
// Gaussian blur and a semi-transparent black overlay are applied on top.
//
// DATA FLOW
// ---------
// 1. _extractColors     Entry point. Returns cached result immediately, or
//                       delegates to _fetch (deduplicating concurrent calls
//                       for the same URI via _pendingRequests).
//
// 2. _resolveImageSize  Resolves pixel dimensions via the ImageProvider stream.
//                       Must complete before palette calls because
//                       Rect.fromLTWH requires absolute pixel coordinates.
//
// 3. _fetch             Fires 9 parallel PaletteGeneratorMaster calls, one per
//                       grid region in row-major order (TL, TC, TR, CL, CC, CR,
//                       BL, BC, BR). All calls use ColorSpace.lab (perceptually
//                       uniform) and filters: const [] (bypasses the default
//                       exclusion filter so blacks/whites/grays are included).
//                       Average lightness is computed by folding across all nine
//                       region palettes combined, which tile the whole image and
//                       avoid the need for a separate full-image palette call.
//
// 4. Color selection    Per-region colors are selected in two passes:
//
//                       Pass 1 - Top and bottom rows are processed first using
//                       _colorFromPalette, which picks the most-populous color
//                       that passes the usability test (_isUsableColor).
//
//                       Pass 2 - If both the top AND bottom row averages fall
//                       below _surroundingDarkThreshold, the center row switches
//                       to _lighterColorFromPalette, which scores candidates by
//                       lightness x saturation instead of population. This
//                       creates visual separation when the surrounding rows are
//                       dark.
//
// 5. Brightness boost   If the whole-image average lightness is >= _lightThreshold
//                       (i.e. the poster is light-toned), each selected color has
//                       its HSL lightness raised by _lightBoost, clamped to
//                       _maxBoostedLightness. Dark and mid-range posters are left
//                       unchanged.
//
// 6. Caching            The resulting list of 9 Colors is stored in _colorCache
//                       keyed by URI string. The cache persists for the app
//                       session.
//
// RENDERING PIPELINE
// ------------------
// AnimatedOpacity       Wraps the entire visual layer. Uses a ValueKey(cacheKey)
//                       so changing the URI destroys the widget immediately
//                       (no fade-out of the old gradient). Fades in over 400ms
//                       once colors are available.
//
// DecoratedBox          Applied as a foreground decoration over the blurred
//   (foreground)        gradient. A 40% opaque black layer that darkens the
//                       gradient uniformly, improving text contrast.
//
// ImageFiltered         Applies a Gaussian blur (sigmaX/Y = 25, TileMode.decal)
//                       to the custom-painted gradient beneath it. This softens
//                       the hard color boundaries between grid cells.
//
// CustomPaint           Draws the gradient via _GradientPainter. When no colors
//   (_GradientPainter)  are available yet, painter is null and nothing is drawn.
//
// GRADIENT PAINTER
// ----------------
// _GradientPainter tessellates the canvas into 18 triangles (9 regions x 2
// triangles each). Each triangle vertex is assigned a color by calling
// _gridColor, which performs piecewise bilinear interpolation over the 3x3
// anchor grid. This gives a smooth continuous gradient across the whole surface.
//
// The 16 key points that define the mesh are:
//   - 4 corners
//   - 4 edge points   (top-left, top-right, bottom-left, bottom-right dividers)
//   - 4 edge points   (left-upper, left-lower, right-upper, right-lower dividers)
//   - 4 interior      (upper-left, upper-right, lower-left, lower-right intersections)
//
// PIECEWISE BILINEAR INTERPOLATION (_gridColor)
// ----------------------------------------------
// _gridColor(xFraction, yFraction) maps any point in [0,1]x[0,1] to a color
// by selecting the 2x2 sub-cell it falls in (one of four quadrants), normalizing
// the position within that sub-cell to [0,1]x[0,1], then interpolating:
//
//   topInterpolated    = lerp(cellTopLeft,    cellTopRight,    normalizedX)
//   bottomInterpolated = lerp(cellBottomLeft, cellBottomRight, normalizedX)
//   result             = lerp(topInterpolated, bottomInterpolated, normalizedY)
//
// The four quadrants and their anchor colors:
//
//   xFraction <= 0.5, yFraction <= 0.5  ->  topLeft / topCenter / centerLeft / centerCenter
//   xFraction <= 0.5, yFraction >  0.5  ->  centerLeft / centerCenter / bottomLeft / bottomCenter
//   xFraction >  0.5, yFraction <= 0.5  ->  topCenter / topRight / centerCenter / centerRight
//   xFraction >  0.5, yFraction >  0.5  ->  centerCenter / centerRight / bottomCenter / bottomRight
//
// =============================================================================

// ─── Tuning ───────────────────────────────────────────────────────────────────

/// Color used when a region produces no usable saturated color.
const _fallbackColor = Color(0xFF1C1C1E);

/// Whole-image average lightness at or above which a brightness boost is applied.
/// Below this value (dark and mid-range posters) colors keep their natural lightness.
const _lightThreshold = 0.60;

/// How much lightness is added to each color when the image exceeds [_lightThreshold].
const _lightBoost = 0.40;

/// Upper bound on lightness after boosting, preventing colors from washing out to near-white.
const _maxBoostedLightness = 0.80;

/// Average lightness of the top row AND bottom row below which the center row is
/// re-selected to prefer the brightest available saturated color rather than the
/// most-populous one, creating visual separation between the rows.
const _surroundingDarkThreshold = 0.35;

// ─── Cache ───────────────────────────────────────────────────────────────────

final Map<String, List<Color>> _colorCache = {};

// Deduplicates concurrent extraction requests for the same URI so only one
// network fetch and palette calculation runs at a time per image.
final Map<String, Future<List<Color>?>> _pendingRequests = {};

// ─── Widget ───────────────────────────────────────────────────────────────────

/// Splits the poster into nine regions (3 columns x 3 rows), picks the most
/// prominent saturated color from each, and maps them to a GPU-interpolated
/// gradient with a blur applied on top.
class ImageGradientBackground extends StatefulWidget {
  final Uri? imageUri;
  final Map<String, String> httpHeaders;

  const ImageGradientBackground({
    super.key,
    required this.imageUri,
    this.httpHeaders = const {},
  });

  @override
  State<ImageGradientBackground> createState() => _ImageGradientBackgroundState();
}

class _ImageGradientBackgroundState extends State<ImageGradientBackground> {
  static final _blurFilter = ImageFilter.blur(sigmaX: 25, sigmaY: 25, tileMode: TileMode.decal);

  late Future<List<Color>?> _colorsFuture;

  @override
  void initState() {
    super.initState();
    _colorsFuture = _extractColors(widget.imageUri, widget.httpHeaders);
  }

  @override
  void didUpdateWidget(ImageGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUri != widget.imageUri) {
      _colorsFuture = _extractColors(widget.imageUri, widget.httpHeaders);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cacheKey = widget.imageUri?.toString() ?? '';

    return FutureBuilder<List<Color>?>(
      future: _colorsFuture,
      builder: (context, snapshot) {
        final colors = _colorCache[cacheKey] ?? snapshot.data;

        return AnimatedOpacity(
          key: ValueKey(cacheKey),
          duration: const Duration(milliseconds: 400),
          opacity: colors != null ? 1.0 : 0.0,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              color: const Color(0xFF000000).withValues(alpha: 0.4),
            ),
            child: ImageFiltered(
              imageFilter: _blurFilter,
              child: CustomPaint(
                painter: colors != null
                    ? _GradientPainter(
                        topLeft: colors[0],
                        topCenter: colors[1],
                        topRight: colors[2],
                        centerLeft: colors[3],
                        centerCenter: colors[4],
                        centerRight: colors[5],
                        bottomLeft: colors[6],
                        bottomCenter: colors[7],
                        bottomRight: colors[8],
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Color extraction ─────────────────────────────────────────────────────────

Future<List<Color>?> _extractColors(Uri? uri, Map<String, String> headers) {
  if (uri == null) return Future.value(null);
  final cacheKey = uri.toString();
  final cached = _colorCache[cacheKey];
  if (cached != null) return Future.value(cached);
  return _pendingRequests[cacheKey] ??= _fetch(cacheKey, headers);
}

Future<List<Color>?> _fetch(String cacheKey, Map<String, String> headers) async {
  try {
    final provider = CachedNetworkImageProvider(cacheKey, headers: headers);

    // Region rects need absolute pixel dimensions before palette calls can be made.
    final imageSize = await _resolveImageSize(provider);
    final imageWidth = imageSize.width;
    final imageHeight = imageSize.height;

    // 9 parallel palette calls, one per grid region in row-major order (TL to BR).
    // filters: const [] bypasses the default exclusion filter so whites, blacks, and
    // grays are included, ensuring average lightness reflects the true brightness of
    // the poster rather than just its saturated mid-tones.
    final palettes = await Future.wait([
      for (int gridRow = 0; gridRow < 3; gridRow++)
        for (int gridCol = 0; gridCol < 3; gridCol++)
          PaletteGeneratorMaster.fromImageProvider(
            provider,
            region: Rect.fromLTWH(
              gridCol * imageWidth / 3,
              gridRow * imageHeight / 3,
              imageWidth / 3,
              imageHeight / 3,
            ),
            colorSpace: ColorSpace.lab,
            filters: const [],
          ),
    ]);

    // Population-weighted average lightness across all nine regions combined.
    // The regions tile the whole image, so this is equivalent to a whole-image average.
    final allRegionColors = [for (final palette in palettes) ...palette.paletteColors];
    final totalPopulation = allRegionColors.fold<int>(0, (sum, c) => sum + c.population);
    final avgLightness = totalPopulation > 0
        ? allRegionColors.fold<double>(
                0.0,
                (sum, c) => sum + HSLColor.fromColor(c.color).lightness * c.population,
              ) /
              totalPopulation
        : 0.5;

    // Build top and bottom rows first; their average lightness decides the center strategy.
    final topRowColors = [
      _colorFromPalette(palettes[0], avgLightness),
      _colorFromPalette(palettes[1], avgLightness),
      _colorFromPalette(palettes[2], avgLightness),
    ];
    final bottomRowColors = [
      _colorFromPalette(palettes[6], avgLightness),
      _colorFromPalette(palettes[7], avgLightness),
      _colorFromPalette(palettes[8], avgLightness),
    ];

    final topRowAvgLightness = _rowLightnessAvg(topRowColors);
    final bottomRowAvgLightness = _rowLightnessAvg(bottomRowColors);
    final shouldOverrideCenterRow =
        topRowAvgLightness < _surroundingDarkThreshold && bottomRowAvgLightness < _surroundingDarkThreshold;

    final centerRowColors = shouldOverrideCenterRow
        ? [
            _lighterColorFromPalette(palettes[3], avgLightness),
            _lighterColorFromPalette(palettes[4], avgLightness),
            _lighterColorFromPalette(palettes[5], avgLightness),
          ]
        : [
            _colorFromPalette(palettes[3], avgLightness),
            _colorFromPalette(palettes[4], avgLightness),
            _colorFromPalette(palettes[5], avgLightness),
          ];

    final colors = [...topRowColors, ...centerRowColors, ...bottomRowColors];

    _colorCache[cacheKey] = colors;
    return colors;
  } catch (_) {
    return null;
  } finally {
    _pendingRequests.remove(cacheKey);
  }
}

// Resolves the pixel dimensions of [provider] by attaching a one-shot stream
// listener. The ImageProvider API does not expose dimensions directly, so this
// is the only way to obtain them before the image is rendered.
Future<Size> _resolveImageSize(ImageProvider provider) {
  final completer = Completer<Size>();
  final stream = provider.resolve(const ImageConfiguration());
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (imageInfo, _) {
      completer.complete(Size(imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble()));
      stream.removeListener(listener);
    },
    onError: (exception, stackTrace) {
      completer.completeError(exception, stackTrace);
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return completer.future;
}

// ─── Color selection ─────────────────────────────────────────────────────────

// Returns true for colors that make viable gradient anchors. Near-black (L < 0.05),
// near-white (L > 0.95), and near-gray (S < 0.05) are excluded because they produce
// visually flat or indistinct results.
bool _isUsableColor(HSLColor hslColor) =>
    hslColor.lightness > 0.05 && hslColor.lightness < 0.95 && hslColor.saturation > 0.05;

// Applies a brightness boost when the image average exceeds _lightThreshold.
// Returns [original] unchanged when no boost is needed.
Color _applyBoost(Color original, HSLColor hslColor, double avgLightness) {
  if (avgLightness >= _lightThreshold) {
    return hslColor.withLightness((hslColor.lightness + _lightBoost).clamp(0.0, _maxBoostedLightness)).toColor();
  }
  return original;
}

// Returns the most-populous usable color in the region, with boost applied if needed.
Color _colorFromPalette(PaletteGeneratorMaster palette, double avgLightness) {
  for (final paletteColor in palette.paletteColors) {
    final hslColor = HSLColor.fromColor(paletteColor.color);
    if (_isUsableColor(hslColor)) {
      return _applyBoost(paletteColor.color, hslColor, avgLightness);
    }
  }
  return _fallbackColor;
}

// Returns the average HSL lightness across the three colors in a row.
double _rowLightnessAvg(List<Color> row) =>
    (HSLColor.fromColor(row[0]).lightness +
        HSLColor.fromColor(row[1]).lightness +
        HSLColor.fromColor(row[2]).lightness) /
    3;

// Selects the color furthest from black by scoring lightness x saturation,
// rewarding vivid bright colors over pale washed-out ones or dark vivid ones.
// Used for the center row when surrounding rows are dark.
Color _lighterColorFromPalette(PaletteGeneratorMaster palette, double avgLightness) {
  Color? bestColor;
  HSLColor? bestHslColor;
  double bestColorScore = -1;

  for (final paletteColor in palette.paletteColors) {
    final hslColor = HSLColor.fromColor(paletteColor.color);
    if (_isUsableColor(hslColor)) {
      final colorScore = hslColor.lightness * hslColor.saturation;
      if (colorScore > bestColorScore) {
        bestColorScore = colorScore;
        bestColor = paletteColor.color;
        bestHslColor = hslColor;
      }
    }
  }

  if (bestColor == null) return _fallbackColor;
  return _applyBoost(bestColor, bestHslColor!, avgLightness);
}

// ─── Painter ──────────────────────────────────────────────────────────────────

// Renders a smooth 3x3 gradient by dividing the canvas into nine regions,
// each split into two triangles (18 triangles total).
class _GradientPainter extends CustomPainter {
  static final _paint = Paint();

  final Color topLeft;
  final Color topCenter;
  final Color topRight;
  final Color centerLeft;
  final Color centerCenter;
  final Color centerRight;
  final Color bottomLeft;
  final Color bottomCenter;
  final Color bottomRight;

  const _GradientPainter({
    required this.topLeft,
    required this.topCenter,
    required this.topRight,
    required this.centerLeft,
    required this.centerCenter,
    required this.centerRight,
    required this.bottomLeft,
    required this.bottomCenter,
    required this.bottomRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftX = size.width / 3;
    final rightX = 2 * size.width / 3;
    final upperY = size.height / 3;
    final lowerY = 2 * size.height / 3;

    // 16 key Offset points: 4 corners + 8 edge divider points + 4 interior intersections
    const cornerTopLeft = Offset.zero;
    final cornerTopRight = Offset(size.width, 0);
    final cornerBottomRight = Offset(size.width, size.height);
    final cornerBottomLeft = Offset(0, size.height);
    final topEdgeLeft = Offset(leftX, 0);
    final topEdgeRight = Offset(rightX, 0);
    final bottomEdgeLeft = Offset(leftX, size.height);
    final bottomEdgeRight = Offset(rightX, size.height);
    final leftEdgeUpper = Offset(0, upperY);
    final leftEdgeLower = Offset(0, lowerY);
    final rightEdgeUpper = Offset(size.width, upperY);
    final rightEdgeLower = Offset(size.width, lowerY);
    final interiorUpperLeft = Offset(leftX, upperY);
    final interiorUpperRight = Offset(rightX, upperY);
    final interiorLowerLeft = Offset(leftX, lowerY);
    final interiorLowerRight = Offset(rightX, lowerY);

    // Interpolated colors at each non-corner key point
    final colorTopEdgeLeft = _gridColor(1 / 3, 0);
    final colorTopEdgeRight = _gridColor(2 / 3, 0);
    final colorBottomEdgeLeft = _gridColor(1 / 3, 1);
    final colorBottomEdgeRight = _gridColor(2 / 3, 1);
    final colorLeftEdgeUpper = _gridColor(0, 1 / 3);
    final colorLeftEdgeLower = _gridColor(0, 2 / 3);
    final colorRightEdgeUpper = _gridColor(1, 1 / 3);
    final colorRightEdgeLower = _gridColor(1, 2 / 3);
    final colorInteriorUpperLeft = _gridColor(1 / 3, 1 / 3);
    final colorInteriorUpperRight = _gridColor(2 / 3, 1 / 3);
    final colorInteriorLowerLeft = _gridColor(1 / 3, 2 / 3);
    final colorInteriorLowerRight = _gridColor(2 / 3, 2 / 3);

    // Nine regions, each split into 2 triangles (18 triangles total)
    final vertices = Vertices(
      VertexMode.triangles,
      [
        // Top-left
        cornerTopLeft, topEdgeLeft, interiorUpperLeft,
        cornerTopLeft, interiorUpperLeft, leftEdgeUpper,
        // Top-center
        topEdgeLeft, topEdgeRight, interiorUpperRight,
        topEdgeLeft, interiorUpperRight, interiorUpperLeft,
        // Top-right
        topEdgeRight, cornerTopRight, rightEdgeUpper,
        topEdgeRight, rightEdgeUpper, interiorUpperRight,
        // Center-left
        leftEdgeUpper, interiorUpperLeft, interiorLowerLeft,
        leftEdgeUpper, interiorLowerLeft, leftEdgeLower,
        // Center-center
        interiorUpperLeft, interiorUpperRight, interiorLowerRight,
        interiorUpperLeft, interiorLowerRight, interiorLowerLeft,
        // Center-right
        interiorUpperRight, rightEdgeUpper, rightEdgeLower,
        interiorUpperRight, rightEdgeLower, interiorLowerRight,
        // Bottom-left
        leftEdgeLower, interiorLowerLeft, bottomEdgeLeft,
        leftEdgeLower, bottomEdgeLeft, cornerBottomLeft,
        // Bottom-center
        interiorLowerLeft, interiorLowerRight, bottomEdgeRight,
        interiorLowerLeft, bottomEdgeRight, bottomEdgeLeft,
        // Bottom-right
        interiorLowerRight, rightEdgeLower, cornerBottomRight,
        interiorLowerRight, cornerBottomRight, bottomEdgeRight,
      ],
      colors: [
        // Top-left
        topLeft, colorTopEdgeLeft, colorInteriorUpperLeft,
        topLeft, colorInteriorUpperLeft, colorLeftEdgeUpper,
        // Top-center
        colorTopEdgeLeft, colorTopEdgeRight, colorInteriorUpperRight,
        colorTopEdgeLeft, colorInteriorUpperRight, colorInteriorUpperLeft,
        // Top-right
        colorTopEdgeRight, topRight, colorRightEdgeUpper,
        colorTopEdgeRight, colorRightEdgeUpper, colorInteriorUpperRight,
        // Center-left
        colorLeftEdgeUpper, colorInteriorUpperLeft, colorInteriorLowerLeft,
        colorLeftEdgeUpper, colorInteriorLowerLeft, colorLeftEdgeLower,
        // Center-center
        colorInteriorUpperLeft, colorInteriorUpperRight, colorInteriorLowerRight,
        colorInteriorUpperLeft, colorInteriorLowerRight, colorInteriorLowerLeft,
        // Center-right
        colorInteriorUpperRight, colorRightEdgeUpper, colorRightEdgeLower,
        colorInteriorUpperRight, colorRightEdgeLower, colorInteriorLowerRight,
        // Bottom-left
        colorLeftEdgeLower, colorInteriorLowerLeft, colorBottomEdgeLeft,
        colorLeftEdgeLower, colorBottomEdgeLeft, bottomLeft,
        // Bottom-center
        colorInteriorLowerLeft, colorInteriorLowerRight, colorBottomEdgeRight,
        colorInteriorLowerLeft, colorBottomEdgeRight, colorBottomEdgeLeft,
        // Bottom-right
        colorInteriorLowerRight, colorRightEdgeLower, bottomRight,
        colorInteriorLowerRight, bottomRight, colorBottomEdgeRight,
      ],
    );

    canvas.drawVertices(vertices, BlendMode.srcOver, _paint);
  }

  // Piecewise bilinear interpolation over the 3x3 color grid.
  // xFraction = x/width, yFraction = y/height, both in [0, 1].
  // The nine anchors sit at the grid intersections:
  //   (0,0)=topLeft     (0.5,0)=topCenter     (1,0)=topRight
  //   (0,0.5)=centerLeft  (0.5,0.5)=centerCenter  (1,0.5)=centerRight
  //   (0,1)=bottomLeft  (0.5,1)=bottomCenter  (1,1)=bottomRight
  Color _gridColor(double xFraction, double yFraction) {
    final double normalizedX, normalizedY;
    final Color cellTopLeft, cellTopRight, cellBottomLeft, cellBottomRight;

    if (xFraction <= 0.5) {
      normalizedX = xFraction / 0.5;
      if (yFraction <= 0.5) {
        normalizedY = yFraction / 0.5;
        cellTopLeft = topLeft;
        cellTopRight = topCenter;
        cellBottomLeft = centerLeft;
        cellBottomRight = centerCenter;
      } else {
        normalizedY = (yFraction - 0.5) / 0.5;
        cellTopLeft = centerLeft;
        cellTopRight = centerCenter;
        cellBottomLeft = bottomLeft;
        cellBottomRight = bottomCenter;
      }
    } else {
      normalizedX = (xFraction - 0.5) / 0.5;
      if (yFraction <= 0.5) {
        normalizedY = yFraction / 0.5;
        cellTopLeft = topCenter;
        cellTopRight = topRight;
        cellBottomLeft = centerCenter;
        cellBottomRight = centerRight;
      } else {
        normalizedY = (yFraction - 0.5) / 0.5;
        cellTopLeft = centerCenter;
        cellTopRight = centerRight;
        cellBottomLeft = bottomCenter;
        cellBottomRight = bottomRight;
      }
    }

    final topInterpolated = Color.lerp(cellTopLeft, cellTopRight, normalizedX)!;
    final bottomInterpolated = Color.lerp(cellBottomLeft, cellBottomRight, normalizedX)!;
    return Color.lerp(topInterpolated, bottomInterpolated, normalizedY)!;
  }

  @override
  bool shouldRepaint(covariant _GradientPainter old) =>
      topLeft != old.topLeft ||
      topCenter != old.topCenter ||
      topRight != old.topRight ||
      centerLeft != old.centerLeft ||
      centerCenter != old.centerCenter ||
      centerRight != old.centerRight ||
      bottomLeft != old.bottomLeft ||
      bottomCenter != old.bottomCenter ||
      bottomRight != old.bottomRight;
}
