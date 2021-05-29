import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                  'A Few Final Things',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                                children: const [
                                  Padding(
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
                                    child: Text(
                                      'Keep an eye out on the Announcements page, this is the primary method for communicating critical information outside of the changelog',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
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
                                    child: Text(
                                      'For help with issues or to provide feedback check out \'Help & Support\' under the Settings page',
                                      style: TextStyle(fontSize: 16),
                                    ),
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
                                  children: const [
                                    Padding(
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
                                      child: Text(
                                        'Don\'t forget to configure Tautulli Remote as a notification agent in Tautulli under Settings > Notification Agents.',
                                        style: TextStyle(fontSize: 16),
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
