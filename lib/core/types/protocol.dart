enum Protocol {
  http,
  https,
}

extension ProtocolToString on Protocol {
  String toShortString() {
    return toString().split('.').last;
  }
}
