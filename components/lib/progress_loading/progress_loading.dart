// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

/// @author DICKY
/// @email <dicky.maulana@pitik.id>
/// @create date 14/09/2023

class ProgressLoading extends StatelessWidget {
  const ProgressLoading({super.key, this.height = 80, this.width = 80});
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
