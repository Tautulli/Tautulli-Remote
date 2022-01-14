import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text('test'),
            ElevatedButton(
              onPressed: () {},
              child: Text('Elevated'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Text'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text('Outlined'),
            ),
          ],
        ),
      ),
    );
  }
}
