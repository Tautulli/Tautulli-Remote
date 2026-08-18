import 'dart:convert';

import '../../features/settings/data/models/custom_header_model.dart';
import '../error/exception.dart';

({List<CustomHeaderModel> headers, String logMessage}) applyCustomHeaderUpdate({
  required List<CustomHeaderModel> headers,
  required bool basicAuth,
  required String title,
  required String subtitle,
  String? previousTitle,
}) {
  String logMessage = 'Header changed but logging missed it';
  final List<CustomHeaderModel> updated = [...headers];

  if (basicAuth) {
    final currentIndex = updated.indexWhere(
      (header) => header.key == 'Authorization',
    );

    final String base64Value = base64Encode(
      utf8.encode('$title:$subtitle'),
    );

    if (currentIndex == -1) {
      updated.add(
        CustomHeaderModel(
          key: 'Authorization',
          value: 'Basic $base64Value',
        ),
      );
      logMessage = "Added 'Authorization' header";
    } else {
      updated[currentIndex] = CustomHeaderModel(
        key: 'Authorization',
        value: 'Basic $base64Value',
      );
      logMessage = "Updated 'Authorization' header";
    }
  } else {
    if (previousTitle != null) {
      final oldIndex = updated.indexWhere(
        (header) => header.key == previousTitle,
      );
      if (oldIndex == -1) {
        updated.add(
          CustomHeaderModel(
            key: title,
            value: subtitle,
          ),
        );
      } else {
        updated[oldIndex] = CustomHeaderModel(
          key: title,
          value: subtitle,
        );
      }
      if (previousTitle != title) {
        logMessage = "Replaced '$previousTitle' header with '$title'";
      } else {
        logMessage = "Updated '$title' header'";
      }
    } else {
      // No previous title means a new header is being added. We need to
      // check and make sure we don't end up with headers that have duplicate
      // keys/titles
      final currentIndex = updated.indexWhere(
        (header) => header.key == title,
      );
      if (currentIndex == -1) {
        updated.add(
          CustomHeaderModel(
            key: title,
            value: subtitle,
          ),
        );
        logMessage = "Added '$title' header";
      } else {
        updated[currentIndex] = CustomHeaderModel(
          key: title,
          value: subtitle,
        );
        logMessage = "Updated '$title' header";
      }
    }
  }

  return (headers: updated, logMessage: logMessage);
}

List<CustomHeaderModel> sortCustomHeaders(List<CustomHeaderModel> headers) {
  final sorted = [...headers];
  sorted.sort((a, b) => a.key.compareTo(b.key));
  final index = sorted.indexWhere((element) => element.key == 'Authorization');
  if (index != -1) {
    final authHeader = sorted.removeAt(index);
    sorted.insert(0, authHeader);
  }
  return sorted;
}

// HTTP header field names are tokens (RFC 7230 §3.2 / RFC 9110 §5.6.2): one or
// more `tchar`.
final _headerNameToken = RegExp(r"^[!#$%&'*+\-.^_`|~0-9A-Za-z]+$");

/// Whether [key] is a valid HTTP header field name, ignoring surrounding
/// whitespace because the form saves a trimmed key.
bool isValidHeaderName(String key) => _headerNameToken.hasMatch(key.trim());

/// Whether [value] is a valid HTTP header field value.
///
/// The same rule as dart:io's `_isValueChar`: a code unit from 32 to 127, or a
/// tab. That covers CR and LF, which would otherwise allow header injection, and
/// also anything non-ASCII — an accented letter or an emoji reaches the socket as
/// a `FormatException` rather than a request.
bool isValidHeaderValue(String value) =>
    value.codeUnits.every((unit) => (unit > 31 && unit < 128) || unit == 9);

/// Throws [InvalidHeaderException] if any entry in [headers] has a name or value
/// that HTTP (and dart:io) would reject.
///
/// Called before a request is built so a malformed custom header surfaces as a
/// clear configuration error rather than a `FormatException` flattened into a
/// generic connection failure at send time.
void validateHeadersOrThrow(Map<String, String> headers) {
  for (final entry in headers.entries) {
    // Checked as stored rather than trimmed: a header saved before these rules
    // existed can carry surrounding whitespace, which dart:io rejects.
    if (!_headerNameToken.hasMatch(entry.key) || !isValidHeaderValue(entry.value)) {
      throw InvalidHeaderException();
    }
  }
}
