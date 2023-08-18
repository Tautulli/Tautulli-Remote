enum ThemeType {
  tautulli('tautulli'),
  dynamic('dynamic');

  final String value;
  const ThemeType(this.value);

  String themeName() => value;
}
