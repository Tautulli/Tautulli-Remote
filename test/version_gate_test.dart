import 'package:flutter_test/flutter_test.dart';
import 'package:tautulli_remote/core/requirements/tautulli_version.dart';

void main() {
  test('supportsPush gates on the push-capable release', () {
    // Real values a Tautulli server reports in register_device responses.
    expect(MinimumVersion.supportsPush('v2.15.3'), isFalse, reason: 'current release predates push');
    expect(MinimumVersion.supportsPush('2.15.3'), isFalse, reason: 'without the v prefix');
    expect(MinimumVersion.supportsPush('v2.16.0'), isTrue, reason: 'the push-capable release itself');
    expect(MinimumVersion.supportsPush('v2.17.1'), isTrue, reason: 'newer');
    expect(MinimumVersion.supportsPush('v2.15.3-beta'), isFalse, reason: 'prerelease of an older version');
    // Fail-open cases: better than warning every user whose server reports oddly.
    expect(MinimumVersion.supportsPush(null), isTrue, reason: 'absent version fails open');
    expect(MinimumVersion.supportsPush('garbage'), isTrue, reason: 'unparsable fails open');
  });
}
