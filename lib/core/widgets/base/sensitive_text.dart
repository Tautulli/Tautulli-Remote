import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';

extension SensitiveTextExtension on Text {
  Widget sensitive({
    bool enabled = true,
    int? length,
  }) {
    if (!enabled) return this;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          return previous.appSettings.maskSensitiveInfo != current.appSettings.maskSensitiveInfo;
        }
        return true;
      },
      builder: (context, state) {
        state as SettingsSuccess;

        if (state.appSettings.maskSensitiveInfo) {
          return Text(
            _redactedStringOfLength(length),
            key: key,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            selectionColor: selectionColor,
          );
        }
        return this;
      },
    );
  }
}

extension SensitiveStringExtension on String {
  String sensitive(BuildContext context, {bool enabled = true, int? length}) {
    if (!enabled) return this;
    final state = context.read<SettingsBloc>().state;
    if (state is SettingsSuccess && state.appSettings.maskSensitiveInfo) {
      return _redactedStringOfLength(length);
    }
    return this;
  }
}

extension SensitiveNullableStringExtension on String? {
  String? sensitive(BuildContext context, {bool enabled = true, int? length}) {
    if (!enabled) return this;
    final state = context.read<SettingsBloc>().state;
    if (state is SettingsSuccess && state.appSettings.maskSensitiveInfo) {
      return _redactedStringOfLength(length);
    }
    return this;
  }
}

extension SensitiveTextSpanExtension on TextSpan {
  TextSpan sensitive(BuildContext context, {bool enabled = true, int? length}) {
    assert(children == null, 'sensitive() cannot be used on a TextSpan with children set.');
    if (!enabled) return this;
    final state = context.read<SettingsBloc>().state;
    if (state is SettingsSuccess && state.appSettings.maskSensitiveInfo) {
      return TextSpan(
        text: _redactedStringOfLength(length),
        style: style,
        recognizer: recognizer,
        mouseCursor: mouseCursor,
        onEnter: onEnter,
        onExit: onExit,
        semanticsLabel: semanticsLabel,
        locale: locale,
        spellOut: spellOut,
      );
    }
    return this;
  }
}

String _redactedStringOfLength(int? length) => length == null ? redactedString : '●' * length;

const redactedString = '●●●●●●●●●●';
