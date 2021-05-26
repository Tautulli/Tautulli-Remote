import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../bloc/wizard_bloc.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 34),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration:
                const BoxDecoration(color: TautulliColorPalette.midnight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 75,
                      padding: const EdgeInsets.only(right: 3),
                      child: Image.asset('assets/logo/logo_transparent.png'),
                    ),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tautulli',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'Remote',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
                'Welcome to Tautulli Remote. This app connects to your existing Tautulli instances to view activity, history, stats, and more. In order to set up Tautulli Remote please make sure Tautulli is currently running and you can access it from this device.'),
          ),
          BlocBuilder<WizardBloc, WizardState>(
            builder: (context, state) {
              if (state is WizardLoaded) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: state.gettingStartedAccepted,
                      onChanged: (value) {
                        context.read<WizardBloc>().add(
                              WizardAcceptGettingStarted(value),
                            );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<WizardBloc>().add(
                              WizardAcceptGettingStarted(
                                !state.gettingStartedAccepted,
                              ),
                            );
                      },
                      child: const Text('I can access my Tautulli instance(s)'),
                    ),
                  ],
                );
              }
              return const SizedBox(height: 0, width: 0);
            },
          ),
        ],
      ),
    );
  }
}
