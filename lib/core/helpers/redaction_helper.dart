/// Exception messages routinely embed the request URI, which carries several
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

/// Image requests name the media being viewed, either by rating key or by Plex
/// metadata path. Which title a user was looking at is not needed to fix an
/// image load failure. `img_format` is untouched: it carries no identity.
final _mediaParamPattern = RegExp(r'((?:rating_key|img)=)[^&\s]+', caseSensitive: false);

/// Returns [message] with server addresses, API keys, account ids and the
/// media being requested masked.
String redactSensitive(String message) => message
    .replaceAll(_hostPattern, '<host>')
    .replaceAllMapped(_apiKeyPattern, (match) => '${match[1]}<redacted>')
    .replaceAll(_idPattern, '<id>')
    .replaceAllMapped(_mediaParamPattern, (match) => '${match[1]}<id>');
