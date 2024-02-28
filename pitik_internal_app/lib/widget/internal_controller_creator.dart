import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/internal_app/product_model.dart';
import 'sku_book_so/sku_book_so_controller.dart';
import 'sku_card/sku_card_controller.dart';
import 'sku_card_gr/sku_card_gr_controller.dart';
import 'sku_card_manufacture/sku_card_manufacture_controller.dart';
import 'sku_card_order/sku_card_order_controller.dart';
import 'sku_card_purchase/sku_card_purchase_controller.dart';
import 'sku_card_purchase_internal/sku_card_purchase_internal_controller.dart';
import 'sku_card_remark/sku_card_remark_controller.dart';
import 'sku_reject_so/sku_reject_controller.dart';

class InternalControllerCreator {
  static SkuCardController putSkuCardController(String tag, BuildContext context) {
    return Get.put(SkuCardController(tag: tag, context: context), tag: tag);
  }

  static SkuCardPurchaseController putSkuCardPurchaseController(String tag, BuildContext context) {
    return Get.put(SkuCardPurchaseController(tag: tag, context: context), tag: tag);
  }

  static SkuCardOrderController putSkuCardOrderController(String tag, BuildContext context) {
    return Get.put(SkuCardOrderController(tag: tag, context: context), tag: tag);
  }

  static SkuCardRemarkController putSkuCardRemarkController(String tag, BuildContext context) {
    return Get.put(SkuCardRemarkController(tag: tag, context: context), tag: tag);
  }

  static SkuRejectController putSkuCardRejectSO(String tag, List<Products?> products) {
    return Get.put(
      SkuRejectController(tag: tag, products: products),
      tag: tag,
    );
  }

  static SkuCardGrController putSkuCardGrOrder(String tag, List<Products?> products) {
    return Get.put(
      SkuCardGrController(tag: tag, products: products),
      tag: tag,
    );
  }

  static SkuBookSOController putSkuBookSOController(String tag, List<Products?> products, bool isRemarks) {
    return Get.put(
      SkuBookSOController(tag: tag, products: products, isRemarks: isRemarks),
      tag: tag,
    );
  }

  static SkuCardManufactureController putSkuCardManufactureController(String tag, BuildContext context) {
    return Get.put(
      SkuCardManufactureController(tag: tag, context: context),
      tag: tag,
    );
  }

  static SkuCardPurchaseInternalController putSkuCardPurchaseInternalController(String tag, BuildContext context) {
    return Get.put(SkuCardPurchaseInternalController(tag: tag, context: context), tag: tag);
  }
}
