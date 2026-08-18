/// Exception messages routinely embed the request URI, which carries two things
/// that must not leave the device: the user's Tautulli server address (often a
/// public domain or IP) and the `apikey` query parameter that authenticates to
/// it. Mask both before the text reaches Crashlytics or the exportable log. The
/// path and remaining query survive, so the failing endpoint stays identifiable.
final _hostPattern = RegExp(r'\b[a-zA-Z][a-zA-Z0-9+.-]*://[^/\s]+');
final _apiKeyPattern = RegExp(r'(apikey=)[^&\s]+', caseSensitive: false);

/// Returns [message] with server addresses and API keys masked.
String redactSensitive(String message) => message
    .replaceAll(_hostPattern, '<host>')
    .replaceAllMapped(_apiKeyPattern, (match) => '${match[1]}<redacted>');
