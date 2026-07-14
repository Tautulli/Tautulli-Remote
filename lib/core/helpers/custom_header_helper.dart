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
      updated[oldIndex] = CustomHeaderModel(
        key: title,
        value: subtitle,
      );
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

/// Whether [key] is a valid HTTP header field name.
bool isValidHeaderName(String key) => _headerNameToken.hasMatch(key.trim());

/// Whether [value] is a valid HTTP header field value.
///
/// Rejects CR and LF, which dart:io also rejects and which would otherwise
/// enable header injection.
bool isValidHeaderValue(String value) => !value.contains('\r') && !value.contains('\n');

/// Throws [InvalidHeaderException] if any entry in [headers] has a name or value
/// that HTTP (and dart:io) would reject.
///
/// Called before a request is built so a malformed custom header surfaces as a
/// clear configuration error rather than a `FormatException` flattened into a
/// generic connection failure at send time.
void validateHeadersOrThrow(Map<String, String> headers) {
  for (final entry in headers.entries) {
    if (!isValidHeaderName(entry.key) || !isValidHeaderValue(entry.value)) {
      throw InvalidHeaderException();
    }
  }
}
