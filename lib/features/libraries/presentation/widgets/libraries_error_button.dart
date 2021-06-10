import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/libraries_bloc.dart';

class LibrariesErrorButton extends StatelessWidget {
  final Failure failure;
  final Completer completer;
  final LibrariesEvent librariesEvent;

  const LibrariesErrorButton({
    Key key,
    @required this.failure,
    @required this.completer,
    @required this.librariesEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return failure == SettingsFailure() || failure == MissingServerFailure()
        ? ElevatedButton.icon(
            icon: const FaIcon(
              FontAwesomeIcons.cogs,
              color: TautulliColorPalette.not_white,
            ),
            label: const Text(LocaleKeys.button_go_to_settings).tr(),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/settings');
            },
          )
        : ElevatedButton.icon(
            icon: const FaIcon(
              FontAwesomeIcons.redoAlt,
              color: TautulliColorPalette.not_white,
            ),
            label: const Text(LocaleKeys.button_retry).tr(),
            onPressed: () {
              context.read<LibrariesBloc>().add(librariesEvent);
              return completer.future;
            },
          );
  }
}
