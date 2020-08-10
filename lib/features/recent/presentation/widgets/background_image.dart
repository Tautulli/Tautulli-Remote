import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final String url;

  const BackgroundImage({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
      ],
    );
  }
}
