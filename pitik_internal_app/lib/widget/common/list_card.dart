// /**
//  * @author [Angga Setiawan Wahyudin]
//  * @email [angga.setiawan@pitik.id]
//  * @create date 2023-02-13 14:00:11
//  * @modify date 2023-02-13 14:00:11
//  * @desc [description]
//  */

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:mobile_flutter/engine/model/customer.dart';
// import 'package:mobile_flutter/engine/util/globar_var.dart';

// class CardList extends StatelessWidget {
//   final Customer customer;
//   final Function() onTap;
//   const CardList({
//     super.key,
//     required this.customer,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(10),
//         margin: EdgeInsets.only(top: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.rectangle,
//           border: Border.all(
//             color: AppColors.outlineColor,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SvgPicture.asset("images/pitik_avatar.svg"),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               customer.bussinesName.toString(),
//                               style: AppTextStyle.blackTextStyle.copyWith(
//                                 fontSize: 16,
//                                 fontWeight: AppTextStyle.medium,
//                               ),
//                               overflow: TextOverflow.clip,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 5),
//                             decoration: BoxDecoration(
//                                 color: customer.lastestVisit!.leadStatus == ""
//                                     ? Colors.white
//                                     : customer.lastestVisit!.leadStatus == "Belum"
//                                         ? Color(0xFFFEE4E2)
//                                         : customer.lastestVisit!.leadStatus == "Akan"
//                                             ? Color(0xFFFEEFD2)
//                                             : customer.lastestVisit!.leadStatus == "Pernah"
//                                                 ? Color(0xFFD0F5FD)
//                                                 : Color(0xFFCEFCD8),
//                                 borderRadius: BorderRadius.circular(6)),
//                             child: Center(
//                                 child: Text(
//                               customer.lastestVisit!.leadStatus == ""
//                                   ? ""
//                                   : customer.lastestVisit!.leadStatus == "Belum"
//                                       ? "Belum"
//                                       : customer.lastestVisit!.leadStatus == "Akan"
//                                           ? "Akan"
//                                           : customer.lastestVisit!.leadStatus == "Pernah"
//                                               ? "Pernah"
//                                               : "Rutin",
//                               style: customer.lastestVisit!.leadStatus == ""
//                                   ? TextStyle()
//                                   : customer.lastestVisit!.leadStatus == "Belum"
//                                       ? TextStyle(color: Color(0xFFDD1E25))
//                                       : customer.lastestVisit!.leadStatus == "Akan"
//                                           ? AppTextStyle.primaryTextStyle
//                                           : customer.lastestVisit!.leadStatus == "Pernah"
//                                               ? TextStyle(
//                                                   color: Color(0xFF198BDB))
//                                               : TextStyle(
//                                                   color: Color(0xFF14CB82)),
//                             )),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Text(
//                         "${customer.districtId},",
//                         style: AppTextStyle.subTextStyle.copyWith(fontSize: 10),
//                         overflow: TextOverflow.clip,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Text(
//               "${customer.salecPIC} - ${customer.dateVisit} - ${customer.timeVisit}",
//               style: AppTextStyle.blackTextStyle
//                   .copyWith(fontSize: 10, fontWeight: AppTextStyle.medium),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
