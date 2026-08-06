import 'package:equatable/equatable.dart';

/// Sent as the push token when notifications are unavailable, so the Tautulli
/// server can tell "declined" apart from "not registered yet".
const String pushDisabled = 'push-disabled';

/// The relay's fair-use limit, as reported by its health endpoint.
///
/// [maximum] is `null` while the relay is still measuring real-world usage to
/// decide what the limit should be. That is not the same as "no limit ever": a
/// limit is expected, so anything shown to the user must say so.
class PushLimits extends Equatable {
  final bool enforced;
  final int? maximum;

  const PushLimits({required this.enforced, this.maximum});

  const PushLimits.unknown() : enforced = false, maximum = null;

  @override
  List<Object?> get props => [enforced, maximum];
}

/// How much of the fair use allowance this device has consumed.
///
/// Separate from [PushLimits]: the cap is a property of the relay and comes from
/// its health endpoint, while consumption is per device token and has to be
/// asked for specifically.
class PushUsage extends Equatable {
  final int? used;
  final int? remaining;
  final DateTime? resetsAt;

  const PushUsage({this.used, this.remaining, this.resetsAt});

  const PushUsage.unknown() : used = null, remaining = null, resetsAt = null;

  @override
  List<Object?> get props => [used, remaining, resetsAt];
}

/// Why a relay health check came out the way it did.
///
/// The common failure is the device's own connectivity, which should not be
/// reported as though the relay were down.
enum PushHealth { reachable, offline, unreachable }
