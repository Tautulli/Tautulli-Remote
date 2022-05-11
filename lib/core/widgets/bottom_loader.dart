import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../features/users/presentation/bloc/users_bloc.dart';
import '../error/failure.dart';

class BottomLoader extends StatelessWidget {
  final UsersStatus status;
  final Failure? failure;
  final String? message;
  final String? suggestion;
  final Function()? onTap;

  const BottomLoader({
    super.key,
    required this.status,
    this.failure,
    this.message,
    this.suggestion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return status != UsersStatus.failure
        ? SizedBox(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
              ],
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (message != null)
                              Text(
                                message!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            if (message != null) const Gap(4),
                            const FaIcon(
                              FontAwesomeIcons.arrowRotateRight,
                              size: 16,
                            ),
                          ],
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
