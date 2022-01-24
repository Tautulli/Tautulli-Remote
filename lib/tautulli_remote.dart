import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/helpers/color_palette_helper.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/translation/presentation/pages/help_translate_page.dart';

class TautulliRemote extends StatefulWidget {
  const TautulliRemote({Key? key}) : super(key: key);

  @override
  _TautulliRemoteState createState() => _TautulliRemoteState();
}

class _TautulliRemoteState extends State<TautulliRemote> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(SettingsLoad());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: TautulliColorPalette.midnight,
      ),
    );

    final ThemeData theme = ThemeData(
      appBarTheme: AppBarTheme(
        color: TautulliColorPalette.midnight,
        iconTheme: const IconThemeData(
          color: TautulliColorPalette.notWhite,
        ),
        titleTextStyle: GoogleFonts.openSans(
          textStyle: const TextStyle(
            fontSize: 20,
            color: TautulliColorPalette.notWhite,
          ),
        ),
      ),
      cardColor: TautulliColorPalette
          .midnight, //Flutter's 'About Licenses' page uses the card color
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge;
            }
          },
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: TautulliColorPalette.notWhite,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: TautulliColorPalette.createSwatch(),
        brightness: Brightness.dark,
      ).copyWith(
        secondary: PlexColorPalette.gamboge,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: TautulliColorPalette.gunmetal,
      ),
      dividerTheme: const DividerThemeData(
        color: PlexColorPalette.gamboge,
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: PlexColorPalette.gamboge,
          onPrimary: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: TautulliColorPalette.notWhite,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: TautulliColorPalette.smoke,
          ),
        ),
        // floatingLabelStyle: TextStyle(
        //   color: PlexColorPalette.gamboge,
        // ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: PlexColorPalette.gamboge,
          ),
        ),
        iconColor: TautulliColorPalette.smoke,
        isDense: true,
        labelStyle: TextStyle(
          color: TautulliColorPalette.smoke,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: TautulliColorPalette.notWhite,
        tileColor: TautulliColorPalette.gunmetal,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: PlexColorPalette.gamboge,
          side: const BorderSide(
            color: PlexColorPalette.gamboge,
          ),
        ),
      ),
      primarySwatch: TautulliColorPalette.createSwatch(),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return PlexColorPalette.gamboge;
            }
          },
        ),
      ),
      scaffoldBackgroundColor: TautulliColorPalette.midnight,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: TautulliColorPalette.notWhite,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: PlexColorPalette.gamboge,
        selectionHandleColor: PlexColorPalette.gamboge,
        selectionColor: PlexColorPalette.gamboge,
      ),
      textTheme: GoogleFonts.openSansTextTheme(
        ThemeData.dark().textTheme.copyWith(
              bodyText1: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              bodyText2: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              button: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              caption: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline1: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline2: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline3: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline4: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline5: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              headline6: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              overline: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              subtitle1: const TextStyle(
                color: TautulliColorPalette.notWhite,
              ),
              subtitle2: const TextStyle(
                color: TautulliColorPalette.smoke,
              ),
            ),
      ),
      unselectedWidgetColor: TautulliColorPalette.notWhite,
    );

    return MaterialApp(
      title: 'Tautulli Remote',
      theme: theme,
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
        HelpTranslatePage.routeName: (_) => const HelpTranslatePage(),
      },
      initialRoute: '/settings',
    );
  }
}
