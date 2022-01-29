import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/settings_bloc.dart';

class CustomerHeaderListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLeading;
  final bool sensitive;

  const CustomerHeaderListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.showLeading = true,
    this.sensitive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Material(
          child: ListTile(
            leading: showLeading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 35,
                        child: FaIcon(FontAwesomeIcons.solidAddressCard),
                      ),
                    ],
                  )
                : null,
            title: Text(title),
            subtitle: Text(
              sensitive &&
                      state is SettingsSuccess &&
                      state.appSettings.maskSensitiveInfo
                  ? 'HIDDEN'
                  : subtitle,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            trailing: GestureDetector(
              child: const FaIcon(
                FontAwesomeIcons.solidTimesCircle,
              ),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}
