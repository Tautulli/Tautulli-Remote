import 'package:flutter/material.dart';

class CustomSettingsTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final Function onTap;

  const CustomSettingsTile({
    Key key,
    @required this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: <Widget>[
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: 25,
                      child: icon,
                    ),
                  ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
