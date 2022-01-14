import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/helpers/color_palette_helper.dart';
import 'features/settings/presentation/pages/settings_page.dart';

class TautulliRemote extends StatefulWidget {
  const TautulliRemote({Key? key}) : super(key: key);

  @override
  _TautulliRemoteState createState() => _TautulliRemoteState();
}

class _TautulliRemoteState extends State<TautulliRemote> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final ThemeData theme = ThemeData(
      primarySwatch: TautulliColorPalette.createSwatch(),
      scaffoldBackgroundColor: TautulliColorPalette.midnight,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: TautulliColorPalette.amber,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: TautulliColorPalette.notWhite,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: TautulliColorPalette.notWhite,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: TautulliColorPalette.notWhite,
      ),
    );

    return MaterialApp(
      title: 'Tautulli Remote',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: TautulliColorPalette.amber,
        ),
        textTheme: GoogleFonts.openSansTextTheme(
          ThemeData.dark().textTheme.copyWith(),
        ),
      ),
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor:
                data.textScaleFactor < 1.15 ? data.textScaleFactor : 1.15,
          ),
          child: child!,
        );
      },
      routes: {
        SettingsPage.routeName: (_) => const SettingsPage(),
      },
      initialRoute: '/settings',
    );
  }
}
