/// Exception messages routinely embed the request URI, which carries three
/// things that must not leave the device: the user's Tautulli server address
/// (often a public domain or IP), the `apikey` query parameter that
/// authenticates to it, and opaque account identifiers such as the Plex user id
/// in an avatar URL. Mask all three before the text reaches Crashlytics or the
/// exportable log. The path and remaining query survive, so the failing
/// endpoint stays identifiable.
final _hostPattern = RegExp(r'\b[a-zA-Z][a-zA-Z0-9+.-]*://[^/\s]+');
final _apiKeyPattern = RegExp(r'(apikey=)[^&\s]+', caseSensitive: false);

/// Long hex runs are ids (Plex user ids, device ids, hashes), never anything
/// worth reading in a stack trace. Short segments like `v2` are left alone.
final _idPattern = RegExp(r'\b[0-9a-f]{16,}\b', caseSensitive: false);

/// Returns [message] with server addresses, API keys and account ids masked.
String redactSensitive(String message) => message
    .replaceAll(_hostPattern, '<host>')
    .replaceAllMapped(_apiKeyPattern, (match) => '${match[1]}<redacted>')
    .replaceAll(_idPattern, '<id>');
