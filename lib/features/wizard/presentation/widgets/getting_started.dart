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
            height: 75,
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
                    SizedBox(
                      height: 75,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Welcome to Tautulli Remote. This app connects to your existing Tautulli instances to view activity, history, stats, and more.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'In order to set up Tautulli Remote please make sure Tautulli is currently running and you can access it from this device.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          BlocBuilder<WizardBloc, WizardState>(
            builder: (context, state) {
              if (state is WizardLoaded) {
                return CheckboxListTile(
                  value: state.gettingStartedAccepted,
                  onChanged: (value) {
                    context.read<WizardBloc>().add(
                          WizardAcceptGettingStarted(value),
                        );
                  },
                  title: const Text('I can access my Tautulli instance(s)'),
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
