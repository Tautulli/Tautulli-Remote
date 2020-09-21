import 'dart:ui';

import 'package:flutter/material.dart';

import 'poster_chooser.dart';

class PosterCard extends StatelessWidget {
  final dynamic item;
  final Widget details;

  const PosterCard({
    Key key,
    @required this.item,
    @required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(4),
          child: Stack(
            children: [
              Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.network(
                      item.posterUrl != null ? item.posterUrl : '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ],
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ),
                child: Row(
                  children: [
                    PosterChooser(item: item),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: details,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
