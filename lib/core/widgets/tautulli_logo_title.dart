import 'package:flutter/material.dart';

class TautulliLogoTitle extends StatelessWidget {
  const TautulliLogoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
    );
  }
}
