import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/bullet_list.dart';
import '../widgets/custom_header_list_tile.dart';
import '../widgets/registration_exit_dialog.dart';
import '../widgets/registration_instruction.dart';

class ServerRegistrationPage extends StatelessWidget {
  const ServerRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ServerRegistrationView();
  }
}

class ServerRegistrationView extends StatelessWidget {
  const ServerRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Registration'),
      ),
      body: WillPopScope(
        onWillPop: () async => await showDialog(
          context: context,
          builder: (context) => const RegistrationExitDialog(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: ListView(
              children: const [
                StepOne(),
                Gap(16),
                StepTwo(),
                Gap(16),
                StepThree(),
                Gap(16),
                StepFour(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StepOne extends StatelessWidget {
  const StepOne({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RegistrationInstruction(
      heading: 'Step 1',
      child: BulletList(
        listItems: [
          'Open the Tautulli web interface on another device.',
          'Navigate to Settings > Tautulli Remote App.',
          "Select 'Register a new device'.",
          'Make sure the Tautulli Address is accessible from other devices.',
        ],
      ),
    );
  }
}

class StepTwo extends StatelessWidget {
  const StepTwo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegistrationInstruction(
      heading: 'Step 2',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BulletList(
            listItems: [
              'Scan the QR code in Tautulli or manually enter the connection address and device token information.',
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Scan QR Code'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'or',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          const Gap(8),
          TextFormField(
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Primary Connection Address',
            ),
          ),
          const Gap(16),
          TextFormField(
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Secondary Connection Address',
              suffixIcon: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.solidQuestionCircle,
                    ),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Secondary Connection Address',
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'The Secondary Connection Address will be used if the Primary Connection Address is unreachable.',
                                ),
                                Gap(8),
                                Text(
                                  'This is particularly useful if your public IP address is not accessible inside your network.',
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: const Text('CLOSE'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const Gap(16),
          TextFormField(
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Device Token',
            ),
          ),
          const Gap(4),
        ],
      ),
    );
  }
}

class StepThree extends StatelessWidget {
  const StepThree({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegistrationInstruction(
      heading: 'Step 3',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BulletList(
            listItems: ['Add any customer headers needed.'],
          ),
          const CustomerHeaderListTile(
            title: 'Authorization',
            subtitle: 'Value',
            showLeading: false,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Add Custom Header'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StepFour extends StatelessWidget {
  const StepFour({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegistrationInstruction(
      heading: 'Step 4',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BulletList(
            listItems: ['Register your Tautulli server.'],
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Register Server'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
