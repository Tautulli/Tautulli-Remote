import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/activity_bloc.dart';

class ActivityErrorButton extends StatelessWidget {
  final Failure failure;
  final Completer completer;

  const ActivityErrorButton({
    Key key,
    @required this.failure,
    @required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return failure == SettingsFailure() || failure == MissingServerFailure()
        ? ElevatedButton.icon(
            icon: FaIcon(
              FontAwesomeIcons.cogs,
              color: TautulliColorPalette.not_white,
            ),
            label: Text('Go to settings'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/settings');
            },
          )
        : ElevatedButton.icon(
            icon: FaIcon(
              FontAwesomeIcons.redoAlt,
              color: TautulliColorPalette.not_white,
            ),
            label: Text('Retry'),
            onPressed: () {
              context.read<ActivityBloc>().add(
                    ActivityLoadAndRefresh(
                      settingsBloc: context.read<SettingsBloc>(),
                    ),
                  );
              return completer.future;
            },
          );
  }
}
