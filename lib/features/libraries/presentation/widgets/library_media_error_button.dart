import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../bloc/library_media_bloc.dart';

class LibraryMediaErrorButton extends StatelessWidget {
  final Failure failure;
  final Completer completer;
  final LibraryMediaEvent libraryMediaEvent;

  const LibraryMediaErrorButton({
    Key key,
    @required this.failure,
    @required this.completer,
    @required this.libraryMediaEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return failure == SettingsFailure() || failure == MissingServerFailure()
        ? ElevatedButton.icon(
            icon: const FaIcon(
              FontAwesomeIcons.cogs,
              color: TautulliColorPalette.not_white,
            ),
            label: const Text('Go to settings'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/settings');
            },
          )
        : ElevatedButton.icon(
            icon: const FaIcon(
              FontAwesomeIcons.redoAlt,
              color: TautulliColorPalette.not_white,
            ),
            label: const Text('Retry'),
            onPressed: () {
              context.read<LibraryMediaBloc>().add(libraryMediaEvent);
              return completer.future;
            },
          );
  }
}
