import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class LoadingFadeWidget extends StatelessWidget {
  double height;
  double width;
  double? radius;
  Color? color;

  LoadingFadeWidget(
      {this.color,
      required this.height,
      required this.width,
      this.radius,
      super.key});

  @override
  Widget build(BuildContext context) {
    return FadeShimmer(
      height: height,
      width: width,
      radius: radius ?? 20,
      highlightColor: color ?? Colors.grey[300],
      baseColor: Colors.grey[600],
    );
  }
}
