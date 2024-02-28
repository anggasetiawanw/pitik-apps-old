import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProgressLoading extends StatelessWidget {
  const ProgressLoading({super.key, this.height = 124, this.width = 124});
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'images/loading.json',
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
