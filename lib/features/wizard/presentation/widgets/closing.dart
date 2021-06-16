import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../translations/locale_keys.g.dart';
import '../bloc/wizard_bloc.dart';

class Closing extends StatelessWidget {
  const Closing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardBloc, WizardState>(
      builder: (context, state) {
        if (state is WizardLoaded) {
          return Padding(
            padding: const EdgeInsets.only(top: 42),
            child: Column(
              children: [
                const Text(
                  LocaleKeys.wizard_closing_title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 4,
                                      right: 16,
                                    ),
                                    child: SizedBox(
                                      width: 25,
                                      child: FaIcon(
                                        FontAwesomeIcons.bullhorn,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: const Text(
                                      LocaleKeys.wizard_closing_announcements,
                                      style: TextStyle(fontSize: 16),
                                    ).tr(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 4,
                                      right: 16,
                                    ),
                                    child: SizedBox(
                                      width: 25,
                                      child: FaIcon(
                                        FontAwesomeIcons.solidLifeRing,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: const Text(
                                      LocaleKeys.wizard_closing_support,
                                      style: TextStyle(fontSize: 16),
                                    ).tr(),
                                  ),
                                ],
                              ),
                            ),
                            if (state.onesignalAccepted)
                              const SizedBox(height: 16),
                            if (state.onesignalAccepted)
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        top: 4,
                                        right: 14,
                                        left: 2,
                                      ),
                                      child: SizedBox(
                                        width: 25,
                                        child: FaIcon(
                                          FontAwesomeIcons.solidBell,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: const Text(
                                        LocaleKeys.wizard_closing_notifications,
                                        style: TextStyle(fontSize: 16),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 4,
                                      right: 17,
                                      left: 7,
                                    ),
                                    child: SizedBox(
                                      width: 25,
                                      child: FaIcon(
                                        FontAwesomeIcons.language,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: const Text(
                                      LocaleKeys.wizard_closing_translate,
                                      style: TextStyle(fontSize: 16),
                                    ).tr(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox(width: 0, height: 0);
      },
    );
  }
}
