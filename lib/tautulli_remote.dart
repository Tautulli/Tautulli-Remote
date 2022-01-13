import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    return MaterialApp(
      title: 'Tautulli Remote',
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tautulli Remote'),
        ),
        body: SafeArea(
          child: Text('test'),
        ),
      ),
    );
  }
}
