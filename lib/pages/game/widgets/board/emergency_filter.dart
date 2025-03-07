import 'dart:async';
import 'package:flutter/material.dart';

class EmergencyEffect extends StatefulWidget {
  const EmergencyEffect({required this.child, super.key});
  final Widget child;

  @override
  State<EmergencyEffect> createState() => _EmergencyEffectState();
}

class _EmergencyEffectState extends State<EmergencyEffect> {
  bool _isFlashing = false;
  Timer? _animationTimer;
  Future<void>? _animationDelayFuture;

  @override
  void initState() {
    super.initState();
    _startFlashing();
  }

  void _startFlashing() {
    _animationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _isFlashing = true;
      });
      _animationDelayFuture = Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isFlashing = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: ClipRect(
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isFlashing ? 0.25 : 0.0,
                child: Container(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _animationDelayFuture?.ignore();
    super.dispose();
  }
}
