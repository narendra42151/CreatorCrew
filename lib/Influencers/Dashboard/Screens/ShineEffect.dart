// Add at the bottom of the file

// Shine animation effect for the motivational message
import 'package:flutter/material.dart';

class ShineEffect extends StatefulWidget {
  final Widget child;

  const ShineEffect({Key? key, required this.child}) : super(key: key);

  @override
  _ShineEffectState createState() => _ShineEffectState();
}

class _ShineEffectState extends State<ShineEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // Create animation that repeats
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);

    // Start the animation after a delay and repeat occasionally
    Future.delayed(Duration(seconds: 1), () {
      _controller.repeat(period: Duration(seconds: 5));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.0),
              ],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment(_animation.value - 0.3, 0.0),
              end: Alignment(_animation.value + 0.3, 0.0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
