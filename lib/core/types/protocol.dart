enum Protocol {
  http,
  https;

  String toShortString() => toString().split('.').last;
}
