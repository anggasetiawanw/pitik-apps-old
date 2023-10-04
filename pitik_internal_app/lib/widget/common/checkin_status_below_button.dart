import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckinStatusBelowButton extends StatelessWidget {
    final bool showErrorCheckin;
    final bool isSuccessCheckin;
    final String error;
    const CheckinStatusBelowButton({
        super.key, required this.showErrorCheckin, required this.isSuccessCheckin, required this.error,
    });

    @override
    Widget build(BuildContext context) {
        return showErrorCheckin
            ? Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: isSuccessCheckin
                        ? const Color(0xFFECFDF3)
                        : const Color(0xFFFEF3F2),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                    children: [
                SvgPicture.asset(isSuccessCheckin ? "images/success_checkin.svg" : "images/failed_checkin.svg", height: 14),
                    const SizedBox(
                        width: 10,
                    ),
                    Expanded(
                        child: Text(
                        isSuccessCheckin
                            ? "Selamat kamu berhasil melakukan Check in"
                            : "Checkin Gagal $error, coba Kembali",
                        style: TextStyle(
                            color:
                                isSuccessCheckin
                                    ? const Color(0xFF12B76A)
                                    : const Color(0xFFF04438),
                            fontSize: 10),
                            overflow: TextOverflow.clip,
                        ),
                    )
                    ],
                ),
                )
            : const SizedBox();
    }
}