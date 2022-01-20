import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerHeaderListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLeading;

  const CustomerHeaderListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.showLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          subtitle,
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
  }
}
