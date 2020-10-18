import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/icon_mapper_helper.dart';
import '../../../../core/helpers/string_format_helper.dart';
import '../../../../core/helpers/time_format_helper.dart';
import '../../../../core/widgets/media_type_icon.dart';
import '../../domain/entities/history.dart';

class HistoryDetails extends StatelessWidget {
  final History historyItem;
  const HistoryDetails({
    Key key,
    @required this.historyItem,
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
                historyItem.fullTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: TautulliColorPalette.not_white,
                ),
              ),
              Text(
                _rowTwo(historyItem),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: TautulliColorPalette.not_white,
                ),
              ),
              Text(
                historyItem.friendlyName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: TautulliColorPalette.not_white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _state(historyItem),
                  Row(
                    children: [
                      MediaTypeIcon(
                        mediaType: historyItem.mediaType,
                        iconColor: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      IconMapperHelper.mapWatchedStatusToIcon(
                        historyItem.watchedStatus,
                      ),
                    ],
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

String _rowTwo(History item) {
  switch (item.mediaType) {
    case ('movie'):
    case ('photo'):
      return item.year == null ? '' : item.year.toString();
    case ('episode'):
      return 'S${item.parentMediaIndex} • E${item.mediaIndex}';
    case ('track'):
      return item.parentTitle;
    case ('clip'):
      return '(Clip)';
    default:
      return 'UNKNOWN MEDIA TYPE';
  }
}

Widget _state(History item) {
  if (item.state == null) {
    return Text(
      TimeFormatHelper.cleanDateTime(item.stopped),
      style: TextStyle(
        fontSize: 15,
        color: TautulliColorPalette.not_white,
      ),
    );
  }
  return Row(
    children: [
      SizedBox(
        width: 12,
        child: FaIcon(
          IconMapperHelper.mapStateToIcon(item.state),
          color: Colors.grey,
          size: 14,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(
          StringFormatHelper.capitalize(item.state),
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      )
    ],
  );
}
