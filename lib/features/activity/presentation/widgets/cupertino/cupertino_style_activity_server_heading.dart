import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_heading.dart';

class CupertinoStyleActivityServerHeading extends StatelessWidget {
  final String serverName;
  final bool loading;

  const CupertinoStyleActivityServerHeading({
    super.key,
    required this.serverName,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CupertinoStyleHeading(text: serverName),
                    if (loading)
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: CupertinoActivityIndicator(radius: 7),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
