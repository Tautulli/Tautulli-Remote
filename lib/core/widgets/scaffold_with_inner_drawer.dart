import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:tautulli_remote/core/helpers/color_palette_helper.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../database/data/models/server_model.dart';
import 'page_body.dart';

class ScaffoldWithInnerDrawer extends StatelessWidget {
  final Widget title;
  final Widget body;
  final List<Widget>? actions;

  const ScaffoldWithInnerDrawer({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<InnerDrawerState> _innerDrawerKey =
        GlobalKey<InnerDrawerState>();
    final double screenAspect = MediaQuery.of(context).size.aspectRatio;

    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true,
      swipeChild: true,
      offset: IDOffset.horizontal(
        screenAspect > 1.2 && screenAspect < 1.5
            ? -0.5
            : screenAspect > 1
                ? -0.2
                : screenAspect > 0.85
                    ? -0.1
                    : screenAspect > 0.70
                        ? -0.3
                        : screenAspect < 0.43
                            ? 0.6
                            : 0.4,
      ),
      leftChild: const _AppDrawer(),
      scaffold: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _innerDrawerKey.currentState?.open();
            },
          ),
          title: title,
          actions: actions,
        ),
        body: PageBody(
          child: body,
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);

    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Logo(),
                  // const Gap(16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _ServerSelector(),
                          // ListTile(
                          //   // tileColor:
                          //   //     Theme.of(context).drawerTheme.backgroundColor,
                          //   leading: const FaIcon(
                          //     FontAwesomeIcons.tv,
                          //     size: 20,
                          //   ),
                          //   title: const Text('Activity'),
                          //   onTap: () {},
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  ListTile(
                    // tileColor: Theme.of(context).drawerTheme.backgroundColor,
                    leading: const FaIcon(
                      FontAwesomeIcons.cogs,
                      size: 20,
                    ),
                    title: const Text('Settings'),
                    onTap: () {
                      if (route?.settings.name != '/settings') {
                        Navigator.of(context).pushReplacementNamed('/settings');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.001,
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Needed for space behind status bar
          Container(
            height: MediaQuery.of(context).padding.top,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          const Gap(8),
          // Logo section
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 70,
                        padding: const EdgeInsets.only(right: 3),
                        child: Image.asset('assets/logos/logo_transparent.png'),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Tautulli',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Remote',
                              style: TextStyle(
                                fontSize: 28,
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
          ),
          const Gap(16),
        ],
      ),
    );
  }
}

class _ServerSelector extends StatefulWidget {
  const _ServerSelector({Key? key}) : super(key: key);

  @override
  State<_ServerSelector> createState() => __ServerSelectorState();
}

class __ServerSelectorState extends State<_ServerSelector> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsSuccess && state.serverList.length > 1) {
          List<ServerModel> nonActiveServers = [...state.serverList];
          nonActiveServers.removeWhere(
            (server) =>
                server.tautulliId == state.appSettings.activeServer.tautulliId,
          );

          return ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                isOpen = !isOpen;
              });
            },
            expandedHeaderPadding: const EdgeInsets.all(0),
            elevation: 0,
            children: [
              ExpansionPanel(
                isExpanded: isOpen,
                canTapOnHeader: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                headerBuilder: (context, isExpanded) => ListTile(
                  tileColor: Colors.transparent,
                  leading: WebsafeSvg.asset(
                    'assets/logos/logo_flat.svg',
                    color: Theme.of(context).colorScheme.tertiary,
                    height: 30,
                  ),
                  title: Text(
                    state.appSettings.activeServer.plexName,
                  ),
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: nonActiveServers.map(
                    (server) {
                      return ListTile(
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        leading: const SizedBox(width: 30),
                        title: Text(server.plexName),
                        onTap: () {
                          setState(() {
                            isOpen = !isOpen;
                          });
                          context.read<SettingsBloc>().add(
                                SettingsUpdateActiveServer(
                                  activeServer: server,
                                ),
                              );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          );
        }

        return const SizedBox(height: 0, width: 0);
      },
    );
  }
}
