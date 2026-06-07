enum AppStyle {
  material,
  cupertino;

  String toShortString() => toString().split('.').last;
}
