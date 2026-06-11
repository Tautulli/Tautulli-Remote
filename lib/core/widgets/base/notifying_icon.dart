import 'package:flutter/widgets.dart';

class NotifyingIcon extends StatefulWidget {
  final IconData icon;
  final Color baseColor;
  final Color notifyingColor;
  final double? size;

  const NotifyingIcon({
    super.key,
    required this.icon,
    required this.baseColor,
    required this.notifyingColor,
    this.size,
  });

  @override
  State<NotifyingIcon> createState() => _NotifyingIconState();
}

class _NotifyingIconState extends State<NotifyingIcon> with SingleTickerProviderStateMixin {
  final Duration transitionDuration = const Duration(milliseconds: 500);
  final Duration holdDurationBase = const Duration(seconds: 3);
  final Duration holdDurationNotifying = const Duration(seconds: 1);
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: transitionDuration * 2 + holdDurationBase + holdDurationNotifying,
    )..repeat();

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: widget.baseColor, end: widget.notifyingColor),
        weight: transitionDuration.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: widget.notifyingColor, end: widget.notifyingColor),
        weight: holdDurationNotifying.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: widget.notifyingColor, end: widget.baseColor),
        weight: transitionDuration.inMilliseconds.toDouble(),
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: widget.baseColor, end: widget.baseColor),
        weight: holdDurationBase.inMilliseconds.toDouble(),
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Icon(
          widget.icon,
          color: _colorAnimation.value,
          size: widget.size,
        );
      },
    );
  }
}
