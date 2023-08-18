enum ThemeEnhancementType {
  ultraContrastDark('ultraContrastDark'),
  none('none');

  final String value;
  const ThemeEnhancementType(this.value);

  String name() => value;
}
