// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

import '../../features/announcements/presentation/bloc/announcements_bloc.dart';
import '../helpers/color_palette_helper.dart';

class AppDrawerIcon extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const AppDrawerIcon({
    Key key,
    @required this.innerDrawerKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  innerDrawerKey.currentState.open();
                },
              ),
            ),
            BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
              builder: (context, state) {
                if (state is AnnouncementsSuccess && state.unread) {
                  return Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      height: 13,
                      width: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PlexColorPalette.gamboge.withOpacity(0.9),
                      ),
                    ),
                  );
                }
                return const SizedBox(height: 0, width: 0);
              },
            ),
          ],
        );
      },
    );
  }
}
