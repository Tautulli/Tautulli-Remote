import 'dart:convert';

import '../../features/settings/data/models/custom_header_model.dart';

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
