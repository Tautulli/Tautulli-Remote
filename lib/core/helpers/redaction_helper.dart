/// Tautulli authenticates with an `apikey` query parameter, so any exception
/// that embeds a request URI (`HttpException`, `ClientException`, image-load
/// failures) carries the user's server credential in its message. Strip it
/// before the text reaches Crashlytics or the exportable log. The host and
/// command survive, so the error stays diagnosable.
final _apiKeyPattern = RegExp(r'(apikey=)[^&\s]+', caseSensitive: false);

/// Returns [message] with any `apikey=` value replaced by `<redacted>`.
String redactApiKey(String message) => message.replaceAllMapped(_apiKeyPattern, (match) => '${match[1]}<redacted>');
