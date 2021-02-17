import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../bloc/users_bloc.dart';

class UserErrorButton extends StatelessWidget {
  final Failure failure;
  final Completer completer;
  final UsersEvent usersEvent;

  const UserErrorButton({
    Key key,
    @required this.failure,
    @required this.completer,
    @required this.usersEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (failure == SettingsFailure() || failure == MissingServerFailure()) {
      return ElevatedButton.icon(
        icon: FaIcon(
          FontAwesomeIcons.cogs,
          color: TautulliColorPalette.not_white,
        ),
        label: Text('Go to settings'),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/settings');
        },
      );
    } else {
      return ElevatedButton.icon(
        icon: FaIcon(
          FontAwesomeIcons.redoAlt,
          color: TautulliColorPalette.not_white,
        ),
        label: Text('Retry'),
        onPressed: () {
          context.read<UsersBloc>().add(usersEvent);
          return completer.future;
        },
      );
    }
  }
}
