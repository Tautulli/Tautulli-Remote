import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              historyItem.fullTitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _rowTwo(historyItem),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              historyItem.friendlyName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
          ],
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
                _progressIcon(historyItem.watchedStatus),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

String _rowTwo(History item) {
  switch (item.mediaType) {
    case ('movie'):
    case ('photo'):
      return item.year.toString();
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
        color: Colors.grey,
      ),
    );
  }
  return Row(
    children: [
      _stateIcon(item.state),
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

Widget _stateIcon(String state) {
  IconData icon;

  if (state == 'playing') {
    icon = FontAwesomeIcons.play;
  } else if (state == 'paused') {
    icon = FontAwesomeIcons.pause;
  } else if (state == 'buffering') {
    icon = FontAwesomeIcons.spinner;
  } else {
    icon = FontAwesomeIcons.questionCircle;
  }

  return SizedBox(
    width: 12,
    child: FaIcon(
      icon,
      color: Colors.grey,
      size: 14,
    ),
  );
}

Widget _progressIcon(num watchedStatus) {
  const double size = 16;
  const Color color = Colors.grey;

  if (watchedStatus == 1) {
    return FaIcon(
      FontAwesomeIcons.solidCircle,
      color: color,
      size: size,
    );
  } else if (watchedStatus == 0.5) {
    return Transform.rotate(
      angle: 180 * pi / 180,
      child: FaIcon(
        FontAwesomeIcons.adjust,
        color: color,
        size: size,
      ),
    );
  } else {
    return FaIcon(
      FontAwesomeIcons.circle,
      color: color,
      size: size,
    );
  }
}
