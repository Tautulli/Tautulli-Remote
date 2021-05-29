import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../features/activity/presentation/bloc/activity_bloc.dart';
import '../helpers/color_palette_helper.dart';

class ServerHeader extends StatelessWidget {
  final String serverName;
  final ActivityLoadingState state;
  final Color color;
  final Widget secondWidget;

  const ServerHeader({
    Key key,
    @required this.serverName,
    this.color,
    this.state,
    this.secondWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.transparent,
      padding: const EdgeInsets.only(
        left: 8,
        top: 8.2,
        bottom: 12.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Text(
                serverName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).accentColor,
                ),
              ),
              if (state == ActivityLoadingState.inProgress)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              if (state == ActivityLoadingState.failure)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: FaIcon(
                    FontAwesomeIcons.exclamationCircle,
                    size: 15,
                    color: TautulliColorPalette.not_white,
                  ),
                ),
            ],
          ),
          if (secondWidget != null) secondWidget,
        ],
      ),
    );
  }
}
