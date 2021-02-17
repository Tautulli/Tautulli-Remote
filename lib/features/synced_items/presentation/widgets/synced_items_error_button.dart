import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../bloc/synced_items_bloc.dart';

class SyncedItemsErrorButton extends StatelessWidget {
  final Failure failure;
  final Completer completer;
  final SyncedItemsEvent syncedItemsEvent;

  const SyncedItemsErrorButton({
    Key key,
    @required this.failure,
    @required this.completer,
    @required this.syncedItemsEvent,
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
              context.read<SyncedItemsBloc>().add(syncedItemsEvent);
              return completer.future;
            },
          );
  }
}
