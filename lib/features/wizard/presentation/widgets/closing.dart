import 'package:flutter/material.dart';

import '../../../../core/widgets/bullet_item.dart';

class Closing extends StatelessWidget {
  const Closing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 34),
      child: Column(
        children: [
          const Text(
            'Closing',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 17,
              left: 8.0,
              right: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('A few final things:'),
                      SizedBox(height: 8),
                      BulletItem(
                        'Servers can be reordered on the Settings page',
                      ),
                      SizedBox(height: 8),
                      BulletItem(
                        'Keep an eye out on the Announcements page, this is the primary method for communicating critical information outside of the changelog',
                      ),
                      SizedBox(height: 4),
                      BulletItem(
                        'For help with issues or to provide feedback check out \'Help & Support\' under the Settings page',
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
}