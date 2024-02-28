import 'package:flutter/material.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import '../../utils/enum/terminate_status.dart';

class TerminateStatus extends StatelessWidget {
  const TerminateStatus({required this.terminateStatus, required this.isApproved, super.key});

  final String? terminateStatus;
  final bool isApproved;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: terminateStatus == null
              ? AppColors.grey
              : terminateStatus == EnumTerminateStatus.draft
                  ? const Color(0xFFFEEFD2)
                  : terminateStatus == EnumTerminateStatus.confirmed
                      ? const Color(0xFFD0F5FD)
                      : terminateStatus == EnumTerminateStatus.booked
                          ? AppColors.primaryLight2
                          : terminateStatus == EnumTerminateStatus.finished
                              ? const Color(0xFFCEFCD8)
                              : terminateStatus == EnumTerminateStatus.rejected
                                  ? const Color(0xFFFDDFD1)
                                  : const Color(0xFFFDDFD1),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
        terminateStatus == EnumTerminateStatus.draft
            ? 'Draft'
            : terminateStatus == EnumTerminateStatus.confirmed
                ? 'Terkonfirmasi'
                : terminateStatus == EnumTerminateStatus.booked
                    ? 'Perlu Persetujuan'
                    : terminateStatus == EnumTerminateStatus.finished
                        ? isApproved
                            ? 'Disetujui'
                            : 'Selesai'
                        : terminateStatus == EnumTerminateStatus.rejected
                            ? 'Ditolak'
                            : 'Dibatalkan',
        style: terminateStatus == null
            ? AppTextStyle.blackTextStyle
            : terminateStatus == EnumTerminateStatus.draft
                ? const TextStyle(color: Color(0xFFF47B20))
                : terminateStatus == EnumTerminateStatus.confirmed
                    ? const TextStyle(color: Color(0xFF198BDB))
                    : terminateStatus == EnumTerminateStatus.booked
                        ? const TextStyle(color: Color(0xFFF47B20))
                        : terminateStatus == EnumTerminateStatus.finished
                            ? const TextStyle(color: Color(0xFF14CB82))
                            : terminateStatus == EnumTerminateStatus.rejected
                                ? const TextStyle(color: Color(0xFFDD1E25))
                                : const TextStyle(color: Color(0xFFDD1E25)),
      )),
    );
  }
}
