import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloatingLogo extends StatelessWidget {
  final AnimationController controller;
  final double floatDistance;

  const FloatingLogo({
    super.key,
    required this.controller,
    this.floatDistance = 15,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -floatDistance * controller.value),
          child: child,
        );
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/logo1.svg',
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }
}
