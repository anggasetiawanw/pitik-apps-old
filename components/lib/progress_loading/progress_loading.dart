import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

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
