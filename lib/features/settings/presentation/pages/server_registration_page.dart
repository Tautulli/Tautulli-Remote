import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:validators/validators.dart';

import '../../../../core/widgets/bullet_list.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../dependency_injection.dart' as di;
import '../../data/models/custom_header_model.dart';
import '../bloc/register_device_bloc.dart';
import '../bloc/registration_headers_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/custom_header_type_dialog.dart';
import '../widgets/registration_exit_dialog.dart';
import '../widgets/registration_instruction.dart';

class ServerRegistrationPage extends StatelessWidget {
  const ServerRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<RegisterDeviceBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<RegistrationHeadersBloc>(),
        ),
      ],
      child: const ServerRegistrationView(),
    );
  }
}

class ServerRegistrationView extends StatelessWidget {
  const ServerRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _primaryController = TextEditingController();
    final _secondaryController = TextEditingController();
    final _tokenController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Registration'),
      ),
      body: PageBody(
        child: WillPopScope(
          onWillPop: () async => await showDialog(
            context: context,
            builder: (_) {
              return BlocProvider.value(
                value: context.read<RegistrationHeadersBloc>(),
                child: const RegistrationExitDialog(),
              );
            },
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                const _StepOne(),
                const Gap(8),
                _StepTwo(
                  primaryController: _primaryController,
                  secondaryController: _secondaryController,
                  tokenController: _tokenController,
                ),
                const Gap(8),
                const _StepThree(),
                const Gap(8),
                _StepFour(
                  formKey: _formKey,
                  primaryController: _primaryController,
                  secondaryController: _secondaryController,
                  tokenController: _tokenController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepOne extends StatelessWidget {
  const _StepOne({
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

class _StepTwo extends StatefulWidget {
  final TextEditingController primaryController;
  final TextEditingController secondaryController;
  final TextEditingController tokenController;

  const _StepTwo({
    Key? key,
    required this.primaryController,
    required this.secondaryController,
    required this.tokenController,
  }) : super(key: key);

  @override
  State<_StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<_StepTwo> {
  bool _primaryValid = true;
  bool _secondaryValid = true;
  bool _tokenValid = true;
  final _primaryFocus = FocusNode();
  final _secondaryFocus = FocusNode();
  final _tokenFocus = FocusNode();

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
                  onPressed: () async {
                    //TODO: Create intermediate file
                    final qrCodeScan = await FlutterBarcodeScanner.scanBarcode(
                      '#e5a00d',
                      'CANCEL',
                      false,
                      ScanMode.QR,
                    );

                    if (qrCodeScan != '-1') {
                      try {
                        final List scanResults = qrCodeScan.split('|');

                        widget.primaryController.text = scanResults[0].trim();
                        widget.tokenController.text = scanResults[1].trim();
                      } catch (_) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).errorColor,
                            content: const Text(
                              'Error scanning QR code',
                            ),
                          ),
                        );
                      }
                    }
                  },
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
            controller: widget.primaryController,
            focusNode: _primaryFocus,
            autocorrect: false,
            decoration: InputDecoration(
              labelText:
                  'Primary Connection Address${!_primaryValid ? '*' : ''}',
              labelStyle: TextStyle(
                color: _primaryValid
                    ? Theme.of(context).inputDecorationTheme.labelStyle!.color
                    : Theme.of(context).colorScheme.error,
              ),
              floatingLabelStyle: TextStyle(
                color: !_primaryValid
                    ? Theme.of(context).colorScheme.error
                    : _primaryFocus.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .color,
              ),
            ),
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(_primaryFocus);
              });
            },
            validator: (value) {
              bool validUrl = isURL(
                value,
                protocols: ['http', 'https'],
                requireProtocol: true,
              );

              if (!validUrl) {
                setState(() {
                  _primaryValid = false;
                });
                return 'Enter a valid URL format';
              }
              setState(() {
                _primaryValid = true;
              });
              return null;
            },
          ),
          const Gap(16),
          TextFormField(
            controller: widget.secondaryController,
            focusNode: _secondaryFocus,
            autocorrect: false,
            decoration: InputDecoration(
              labelText:
                  'Secondary Connection Address${!_secondaryValid ? '*' : ''}',
              labelStyle: TextStyle(
                color: _secondaryValid
                    ? Theme.of(context).inputDecorationTheme.labelStyle!.color
                    : Theme.of(context).colorScheme.error,
              ),
              floatingLabelStyle: TextStyle(
                color: !_secondaryValid
                    ? Theme.of(context).colorScheme.error
                    : _secondaryFocus.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .color,
              ),
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
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(_secondaryFocus);
              });
            },
            validator: (value) {
              bool validUrl = isURL(
                value,
                protocols: ['http', 'https'],
                requireProtocol: true,
              );

              if (value != '' && !validUrl) {
                setState(() {
                  _secondaryValid = false;
                });
                return 'Leave blank or enter a valid URL format';
              }
              setState(() {
                _secondaryValid = true;
              });
              return null;
            },
          ),
          const Gap(16),
          TextFormField(
            controller: widget.tokenController,
            focusNode: _tokenFocus,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Device Token${!_tokenValid ? '*' : ''}',
              labelStyle: TextStyle(
                color: _tokenValid
                    ? Theme.of(context).inputDecorationTheme.labelStyle!.color
                    : Theme.of(context).colorScheme.error,
              ),
              floatingLabelStyle: TextStyle(
                color: !_tokenValid
                    ? Theme.of(context).colorScheme.error
                    : _tokenFocus.hasFocus
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder!
                            .borderSide
                            .color,
              ),
            ),
            onTap: () {
              setState(() {
                FocusScope.of(context).requestFocus(_tokenFocus);
              });
            },
            validator: (value) {
              if (value != null && value.length != 32) {
                setState(() {
                  _tokenValid = false;
                });
                return 'Must be 32 characters long (current: ${value.length.toString()})';
              }
              setState(() {
                _tokenValid = true;
              });
              return null;
            },
          ),
          const Gap(4),
        ],
      ),
    );
  }
}

class _StepThree extends StatelessWidget {
  const _StepThree({
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
          BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    state is RegistrationHeadersLoaded ? state.headers : [],
              );
            },
          ),
          // const CustomHeaderListTile(
          //   title: 'Authorization',
          //   subtitle: 'Value',
          //   showLeading: false,
          // ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Add Custom Header'),
                  onPressed: () async => await showDialog(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: context.read<RegistrationHeadersBloc>(),
                        child: const CustomHeaderTypeDialog(),
                      );
                      // return const CustomHeaderTypeDialog();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepFour extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController primaryController;
  final TextEditingController secondaryController;
  final TextEditingController tokenController;

  const _StepFour({
    Key? key,
    required this.formKey,
    required this.primaryController,
    required this.secondaryController,
    required this.tokenController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
      builder: (context, state) {
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<RegisterDeviceBloc>().add(
                                RegisterDeviceStarted(
                                  primaryConnectionAddress:
                                      primaryController.text,
                                  secondaryConnectionAddress:
                                      secondaryController.text,
                                  deviceToken: tokenController.text,
                                  headers: state is RegistrationHeadersLoaded
                                      ? state.headers
                                          .map(
                                            (widget) => CustomHeaderModel(
                                                key: widget.title,
                                                value: widget.subtitle),
                                          )
                                          .toList()
                                      : [],
                                  settingsBloc: context.read<SettingsBloc>(),
                                ),
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    // return BlocListener<RegistrationHeadersBloc, RegistrationHeadersState>(
    //   listener: (context, state) {
    //     if (state is RegistrationHeadersLoaded) {
    //       print('STATE CHANGE DETECTED');
    //       List<CustomHeaderModel> list = [];
    //       for (CustomHeaderListTile headerListTile in state.headers) {
    //         list.add(
    //           CustomHeaderModel(
    //             key: headerListTile.title,
    //             value: headerListTile.subtitle,
    //           ),
    //         );
    //       }

    //       headers = [...list];
    //     }
    //   },
    //   child: RegistrationInstruction(
    //     heading: 'Step 4',
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const BulletList(
    //           listItems: ['Register your Tautulli server.'],
    //         ),
    //         const Gap(8),
    //         Row(
    //           children: [
    //             Expanded(
    //               child: ElevatedButton(
    //                 child: const Text('Register Server'),
    //                 onPressed: () {
    //                   print(headers);
    //                   if (formKey.currentState!.validate()) {
    //                     context.read<RegisterDeviceBloc>().add(
    //                           RegisterDeviceStarted(
    //                             primaryConnectionAddress:
    //                                 primaryController.text,
    //                             secondaryConnectionAddress:
    //                                 secondaryController.text,
    //                             deviceToken: tokenController.text,
    //                             headers: [...headers],
    //                             settingsBloc: context.read<SettingsBloc>(),
    //                           ),
    //                         );
    //                   }
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    // return RegistrationInstruction(
    //   heading: 'Step 4',
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const BulletList(
    //         listItems: ['Register your Tautulli server.'],
    //       ),
    //       const Gap(8),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: ElevatedButton(
    //               child: const Text('Register Server'),
    //               onPressed: () {
    //                 if (formKey.currentState!.validate()) {
    //                   context.read<RegisterDeviceBloc>().add(
    //                         RegisterDeviceStarted(
    //                           primaryConnectionAddress: primaryController.text,
    //                           secondaryConnectionAddress:
    //                               secondaryController.text,
    //                           deviceToken: tokenController.text,
    //                           settingsBloc: context.read<SettingsBloc>(),
    //                         ),
    //                       );
    //                 }
    //               },
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
