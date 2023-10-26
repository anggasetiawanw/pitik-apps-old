import 'package:flutter/cupertino.dart';
import 'package:global_variable/colors.dart';
import 'package:global_variable/text_style.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 12/05/23


class OrderStatus extends StatelessWidget{
  const OrderStatus({super.key, required this.orderStatus, required this.returnStatus, required this.grStatus, this.soPage = false});

  final String? orderStatus;
  final String? returnStatus;
  final String? grStatus;
  final bool? soPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: orderStatus == null ? AppColors.grey :
          orderStatus == "READY_TO_DELIVER" ? const Color(0xFFFEF6D2) :
          orderStatus == "DRAFT" ? const Color(0xFFFEEFD2) :
          orderStatus == "CONFIRMED" ? const Color(0xFFD0F5FD) :
          orderStatus == "CANCELLED" ? const Color(0xFFFDDFD1) :
          orderStatus == "BOOKED" ? const Color(0xFFFAEDCF) :
          orderStatus == "PICKED_UP" ? const Color(0xFFD0F5FD) :
          orderStatus == "REJECTED" && returnStatus == "FULL"? const Color(0xFFFDDFD1) :
          orderStatus == "RETURNED" ? const Color(0xFFD0F5FD) :
          orderStatus == "RECEIVED" ? const Color(0xFFCEFCD8) :
          orderStatus == "ON_DELIVERY" ? const Color(0xFFEAECF5) :
          orderStatus == "DELIVERED" && soPage! ? const Color(0xFFCEFCD8) :
          orderStatus == "REJECTED" && returnStatus == "PARTIAL" && grStatus == "REJECTED" ? const Color(0xFFFEF6D2) :
          orderStatus == "DELIVERED" && returnStatus == "PARTIAL" && grStatus == "REJECTED" ? const Color(0xFFFEF6D2) :
          orderStatus == "DELIVERED" && returnStatus == "PARTIAL" && grStatus == "RECEIVED" ? const Color(0xFFCEFCD8) :
          orderStatus == "REJECTED" && returnStatus == "PARTIAL" && grStatus == "RECEIVED" ? const Color(0xFFCEFCD8) :
          const Color(0xffffffff),
          borderRadius: BorderRadius.circular(6)
      ),
      child: Center(
          child: Text(
            orderStatus == null ? "Draft" :
            orderStatus == "READY_TO_DELIVER" ? "Siap Kirim" :
            orderStatus == "CONFIRMED" ? "Terkonfirmasi" :
            orderStatus == "BOOKED" ? "Dipesan" :
            orderStatus == "CANCELLED" ? "Dibatalkan" :
            orderStatus == "DRAFT" ? "Draft" :
            orderStatus == "PICKED_UP" ? "Dikirim" :
            orderStatus == "RETURNED" ? "Dikembalikan" :
            orderStatus== "ON_DELIVERY" ? "Perjalanan" :
            orderStatus == "DELIVERED" && soPage!? "Terkirim" :
            orderStatus == "REJECTED" && returnStatus == "FULL" ? "Ditolak" :
            orderStatus == "REJECTED" && returnStatus == "PARTIAL" && grStatus == "REJECTED" ? "Terima Sebagian" :
            orderStatus == "REJECTED" && returnStatus == "PARTIAL" && grStatus == "RECEIVED" ? "Diterima" :
            orderStatus == "DELIVERED" && returnStatus == "PARTIAL" && grStatus == "REJECTED" ? "Terima Sebagian" :
            orderStatus == "DELIVERED" && returnStatus == "PARTIAL" && grStatus == "RECEIVED" ? "Diterima" :
            "Draft",

            style: orderStatus == null ? AppTextStyle.blackTextStyle :
            orderStatus == "READY_TO_DELIVER" ? const TextStyle(color: Color(0xFFF4B420)) :
            orderStatus == "DRAFT" ? AppTextStyle.primaryTextStyle :
            orderStatus == "CONFIRMED" ? const TextStyle(color: Color(0xFF198BDB)) :
            orderStatus == "CANCELLED" ? const TextStyle(color: Color(0xFFDD1E25)) :
            orderStatus == "BOOKED" ? const TextStyle(color: Color(0xFFAB6116)) :
            orderStatus == "PICKED_UP" ? const TextStyle(color: Color(0xFF198BDB)) :
            orderStatus == "REJECTED" && returnStatus == "FULL" ? const TextStyle(color: Color(0xFFDD1E25)) :
            orderStatus == "RETURNED" ? const TextStyle(color: Color(0xFF198BDB)) :
            orderStatus == "RECEIVED" ? const TextStyle(color: Color(0xFF14CB82)) :
            orderStatus== "ON_DELIVERY" ? const TextStyle(color: Color(0xFF6938EF)) :
            orderStatus == "DELIVERED" && soPage! ? const TextStyle(color: Color(0xFF14CB82)) :
            orderStatus == "REJECTED" && returnStatus == "PARTIAL" && grStatus == "REJECTED"  ? const TextStyle(color: Color(0xFFF4B420)) :
            orderStatus == "REJECTED" && returnStatus == "PARTIAL" && grStatus == "RECEIVED" ? const TextStyle(color: Color(0xFF14CB82))  :
            orderStatus == "DELIVERED" && returnStatus == "PARTIAL" && grStatus == "REJECTED"  ? const TextStyle(color: Color(0xFFF4B420)) :
            orderStatus == "DELIVERED" && returnStatus == "PARTIAL" && grStatus == "RECEIVED" ? const TextStyle(color: Color(0xFF14CB82))  :

            const TextStyle(color: Color(0xFF14CB82)),
          )
      ),
    );
  }
}