import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../injection_container.dart' as di;
import '../bloc/load_logs_bloc.dart';
import '../widgets/log_table.dart';

// Allows for a Bloc Provider to be set so that
// BlocProvider.of can be used before the Scaffold body.
//
// Issues when accessing BlocProvider.of inside the widget
// where it was instantiated.
class LogsPage extends StatelessWidget {
  const LogsPage({Key key}) : super(key: key);

  static const routeName = '/logs';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogsBloc>(
      create: (context) => di.sl<LogsBloc>()..add(LogsLoad()),
      child: _LogsPageContent(),
    );
  }
}

class _LogsPageContent extends StatefulWidget {
  const _LogsPageContent({Key key}) : super(key: key);

  @override
  _LogsPageContentState createState() => _LogsPageContentState();
}

class _LogsPageContentState extends State<_LogsPageContent> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Tautulli Remote Logs'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'export') {
                // var status = await Permission.storage.status;
                if (await Permission.storage.request().isGranted) {
                  BlocProvider.of<LogsBloc>(context).add(LogsExport());
                }
              }
              if (value == 'clear') {
                return _showClearLogsDialog(
                  context: context,
                  clearLogs: () =>
                      BlocProvider.of<LogsBloc>(context).add(LogsClear()),
                );
              }
              return null;
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Export logs'),
                value: 'export',
              ),
              PopupMenuItem(
                child: Text('Clear logs'),
                value: 'clear',
              ),
            ],
          ),
        ],
      ),
      // drawer: AppDrawer(),
      body: BlocConsumer<LogsBloc, LogsState>(
        listener: (context, state) {
          if (state is LogsSuccess) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
          if (state is LogsExportInProgress) {
            Scaffold.of(context).hideCurrentSnackBar();
            //TODO: add a link to a wiki page for accessing log files
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Logs exported'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LogsInitial) {
            return Container(height: 0, width: 0);
          }
          if (state is LogsFailure) {
            return Center(
              child: Text(
                'Failed to load logs',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          if (state is LogsExportInProgress) {
            return LogTable(
              logs: state.logs,
              refreshCompleter: _refreshCompleter,
            );
          }
          if (state is LogsSuccess) {
            return LogTable(
              logs: state.logs,
              refreshCompleter: _refreshCompleter,
            );
          }
        },
      ),
    );
  }
}

Future _showClearLogsDialog({
  @required BuildContext context,
  @required Function clearLogs,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure you want to clear the Tautulli Remote logs?'),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('CONFIRM'),
            color: Colors.red,
            onPressed: () {
              clearLogs();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
