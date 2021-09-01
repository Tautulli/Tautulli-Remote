// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../core/widgets/media_type_icon.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../domain/entities/recent.dart';

class RecentlyAddedDetails extends StatelessWidget {
  final RecentItem recentItem;

  const RecentlyAddedDetails({
    Key key,
    @required this.recentItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _rowOne(recentItem),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                _rowTwo(recentItem),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                _rowThree(recentItem),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${LocaleKeys.general_added.tr()} ${TimeFormatHelper.timeAgo(recentItem.addedAt)}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  MediaTypeIcon(
                    mediaType: recentItem.mediaType,
                    iconColor: TautulliColorPalette.not_white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _rowOne(RecentItem item) {
  switch (item.mediaType) {
    case ('movie'):
      return item.title;
    case ('episode'):
      return item.grandparentTitle;
    case ('season'):
      return item.parentTitle;
    case ('show'):
      return item.title;
    case ('track'):
      return item.grandparentTitle;
    case ('album'):
      return item.parentTitle;
    default:
      return LocaleKeys.general_unknown.tr();
  }
}

String _rowTwo(RecentItem item) {
  switch (item.mediaType) {
    case ('movie'):
      return item.year.toString();
    case ('episode'):
    case ('season'):
      return item.title;
    case ('show'):
      return '${item.childCount} seasons';
    case ('track'):
      return item.parentTitle;
    case ('album'):
      return item.title;
    default:
      return LocaleKeys.general_unknown.tr();
  }
}

String _rowThree(RecentItem item) {
  switch (item.mediaType) {
    case ('movie'):
      return '';
    case ('episode'):
      return 'S${item.parentMediaIndex} • E${item.mediaIndex}';
    case ('season'):
      return '';
    case ('show'):
      return '';
    case ('track'):
      return item.parentTitle;
    case ('album'):
      return item.year.toString();
    default:
      return LocaleKeys.general_unknown.tr();
  }
}
