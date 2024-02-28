import 'package:flutter/cupertino.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';
import '../../utils/enum/so_status.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 12/05/23

class OrderStatus extends StatelessWidget {
  const OrderStatus({required this.orderStatus, required this.returnStatus, required this.grStatus, super.key, this.soPage = false});

  final String? orderStatus;
  final String? returnStatus;
  final String? grStatus;
  final bool? soPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: orderStatus == null
              ? AppColors.grey
              : orderStatus == EnumSO.readyToDeliver
                  ? const Color(0xFFFEF6D2)
                  : orderStatus == EnumSO.draft
                      ? const Color(0xFFFEEFD2)
                      : orderStatus == EnumSO.confirmed
                          ? const Color(0xFFD0F5FD)
                          : orderStatus == EnumSO.allocated
                              ? const Color(0xFFEAECF5)
                              : orderStatus == EnumSO.cancelled
                                  ? const Color(0xFFFDDFD1)
                                  : orderStatus == EnumSO.booked
                                      ? const Color(0xFFFAEDCF)
                                      : orderStatus == EnumSO.pickedUp
                                          ? const Color(0xFFD0F5FD)
                                          : orderStatus == EnumSO.returned
                                              ? const Color(0xFFD0F5FD)
                                              : orderStatus == EnumSO.received
                                                  ? const Color(0xFFCEFCD8)
                                                  : orderStatus == EnumSO.onDelivery
                                                      ? const Color(0xFFEAECF5)
                                                      : orderStatus == EnumSO.delivered && soPage!
                                                          ? const Color(0xFFCEFCD8)
                                                          : orderStatus == EnumSO.rejected && soPage! && returnStatus == EnumSO.returnedPartial
                                                              ? const Color(0xFFFEF6D2)
                                                              : orderStatus == EnumSO.rejected && soPage!
                                                                  ? const Color(0xFFFDDFD1)
                                                                  : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedFull && grStatus == EnumSO.received
                                                                      ? const Color(0xFFCEFCD8)
                                                                      : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedFull
                                                                          ? const Color(0xFFFDDFD1)
                                                                          : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected
                                                                              ? const Color(0xFFFEF6D2)
                                                                              : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.received
                                                                                  ? const Color(0xFFCEFCD8)
                                                                                  : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected && soPage!
                                                                                      ? const Color(0xFFFDDFD1)
                                                                                      : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected
                                                                                          ? const Color(0xFFFEF6D2)
                                                                                          : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.received
                                                                                              ? const Color(0xFFCEFCD8)
                                                                                              : const Color(0xffffffff),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
        orderStatus == null
            ? 'Draft'
            : orderStatus == EnumSO.readyToDeliver
                ? 'Siap Kirim'
                : orderStatus == EnumSO.confirmed
                    ? 'Terkonfirmasi'
                    : orderStatus == EnumSO.allocated
                        ? 'Teralokasi'
                        : orderStatus == EnumSO.booked
                            ? 'Dipesan'
                            : orderStatus == EnumSO.cancelled
                                ? 'Dibatalkan'
                                : orderStatus == EnumSO.draft
                                    ? 'Draft'
                                    : orderStatus == EnumSO.pickedUp
                                        ? 'Dikirim'
                                        : orderStatus == EnumSO.returned
                                            ? 'Dikembalikan'
                                            : orderStatus == EnumSO.onDelivery
                                                ? 'Perjalanan'
                                                : orderStatus == EnumSO.delivered && soPage!
                                                    ? 'Terkirim'
                                                    : orderStatus == EnumSO.rejected && soPage! && returnStatus == EnumSO.returnedPartial
                                                        ? 'Terkirim Sebagian'
                                                        : orderStatus == EnumSO.rejected && soPage!
                                                            ? 'Ditolak'
                                                            : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedFull && grStatus == EnumSO.received
                                                                ? 'Diterima'
                                                                : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedFull
                                                                    ? 'Ditolak'
                                                                    : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected
                                                                        ? 'Terkirim Sebagian'
                                                                        : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.received
                                                                            ? 'Diterima'
                                                                            : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected && soPage!
                                                                                ? 'Ditolak'
                                                                                : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected
                                                                                    ? 'Terkirim Sebagian'
                                                                                    : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.received
                                                                                        ? 'Diterima'
                                                                                        : 'Draft',
        style: orderStatus == null
            ? AppTextStyle.blackTextStyle
            : orderStatus == EnumSO.readyToDeliver
                ? const TextStyle(color: Color(0xFFF4B420))
                : orderStatus == EnumSO.draft
                    ? AppTextStyle.primaryTextStyle
                    : orderStatus == EnumSO.confirmed
                        ? const TextStyle(color: Color(0xFF198BDB))
                        : orderStatus == EnumSO.cancelled
                            ? const TextStyle(color: Color(0xFFDD1E25))
                            : orderStatus == EnumSO.allocated
                                ? const TextStyle(color: Color(0xFF6938EF))
                                : orderStatus == EnumSO.booked
                                    ? const TextStyle(color: Color(0xFFAB6116))
                                    : orderStatus == EnumSO.pickedUp
                                        ? const TextStyle(color: Color(0xFF198BDB))
                                        : orderStatus == EnumSO.returned
                                            ? const TextStyle(color: Color(0xFF198BDB))
                                            : orderStatus == EnumSO.received
                                                ? const TextStyle(color: Color(0xFF14CB82))
                                                : orderStatus == EnumSO.onDelivery
                                                    ? const TextStyle(color: Color(0xFF6938EF))
                                                    : orderStatus == EnumSO.delivered && soPage!
                                                        ? const TextStyle(color: Color(0xFF14CB82))
                                                        : orderStatus == EnumSO.rejected && soPage! && returnStatus == EnumSO.returnedPartial
                                                            ? const TextStyle(color: Color(0xFFF4B420))
                                                            : orderStatus == EnumSO.rejected && soPage!
                                                                ? const TextStyle(color: Color(0xFFDD1E25))
                                                                : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedFull && grStatus == EnumSO.received
                                                                    ? const TextStyle(color: Color(0xFF14CB82))
                                                                    : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedFull
                                                                        ? const TextStyle(color: Color(0xFFDD1E25))
                                                                        : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected
                                                                            ? const TextStyle(color: Color(0xFFF4B420))
                                                                            : orderStatus == EnumSO.rejected && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.received
                                                                                ? const TextStyle(color: Color(0xFF14CB82))
                                                                                : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected && soPage!
                                                                                    ? const TextStyle(color: Color(0xFFDD1E25))
                                                                                    : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.rejected
                                                                                        ? const TextStyle(color: Color(0xFFF4B420))
                                                                                        : orderStatus == EnumSO.delivered && returnStatus == EnumSO.returnedPartial && grStatus == EnumSO.received
                                                                                            ? const TextStyle(color: Color(0xFF14CB82))
                                                                                            : const TextStyle(color: Color(0xFF14CB82)),
      )),
    );
  }
}
