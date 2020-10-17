import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/error/failure.dart';
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
        ? RaisedButton.icon(
            icon: FaIcon(FontAwesomeIcons.cogs),
            label: Text('Go to settings'),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/settings');
            },
          )
        : RaisedButton.icon(
            icon: FaIcon(FontAwesomeIcons.redoAlt),
            label: Text('Retry'),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              context.bloc<SyncedItemsBloc>().add(syncedItemsEvent);
              return completer.future;
            },
          );
  }
}
