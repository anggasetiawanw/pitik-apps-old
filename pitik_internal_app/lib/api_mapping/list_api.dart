class ListApi {
    static const String createCustomer = "createCustomer";
    static const String getListCustomer = "getListCustomer";
    static const String updateCustomerById = "updateCustomerById";
    static const String detailCustomerById = "detailCustomerById";
    static const String createNewVisit = "createNewVisit";
    static const String getListVisitById = "getListVisitById";
    static const String getListVisit = "getListVisit";
    static const String loginWithGoogle = "loginWithgoogle";
    static const String archiveCustomer = "archiveCustomer";
    static const String searchCustomer = "searchCustomer";
    static const String visitCheckin = "visitCheckin";
    static const String getProvince = "getProvince";
    static const String getCity = "getCity";
    static const String getDistrict = "getDistrict";
    static const String getSalesList = "getSalesList";
    static const String getCategories = "getCategories";
    static const String getProductById = "getProductById";
    static const String searchCustomerVisit = "searchCustomerVisit";
    static const String getSalesProfile = "profile";
    static const String getOrderIssueCategories = "getOrderIssueCategories";
    static const String getPurchaseOrderList = "getPurchaseOrderList";
    static const String detailPurchaseById = "detailPurchaseById";
    static const String cancelPurchase = "cancelPurchase";
    static const String getListVendors = "getListVendors";
    static const String getListJagalExternal = "getListJagalExternal";
    static const String getListOperationUnits = "getListOperationUnits";
    static const String createPurchase = "createPurchase";
    static const String editPurchase = "editPurchase";
    static const String getListOrders = "getListOrders";
    static const String detailOrderById = "detailOrderById";
    static const String createManufacture = "createManufacture";
    static const String getListManufacture = "getListManufacture";
    static const String updateManufactureById = "updateManufactureById";
    static const String detailManufactureById = "detailManufactureById";
    static const String getListStockAggregateByUnit = "getListStockAggregateByUnit";
    static const String getListManufactureOutput = "getListManufactureOutput";
    static const String uploadImage = "uploadImage";
    static const String getListCustomerWithoutPage = "getListCustomerWithoutPage";
    static const String createSalesOrder = "createSalesOrder";
    static const String cancelOrder = "cancelOrder";
    static const String createTerminate = "createTerminate";
    static const String getListTerminate = "getListTerminate";
    static const String updateTerminateById = "updateTerminateById";
    static const String detailTerminateById = "detailTerminateById";
    static const String getListInternalTransfer = "getListInternalTransfer";
    static const String getDetailTransfer = "getDetailTransfer";
    static const String createTransfer = "createTransfer";
    static const String updateTransferById = "updateTransferById";
    static const String transferEditStatus = "transferEditStatus";
    static const String transferStatusDriver = "transferStatusDriver";
    static const String getListDriver = "getListDriver";
    static const String getGoodReceiptPOList = "getGoodReceiptPOList";
    static const String getGoodReceiptTransferList = "getGoodReceiptTransferList";
    static const String getGoodReceiptsOrderList = "getGoodReceiptsOrderList";
    static const String createGoodReceived = "createGoodReceived";
    static const String detailReceivedById = "detailReceivedById";

    static const String createStockOpname = "createStockOpname";
    static const String updateOpnameById = "updateOpnameById";
    static const String getListOpname = "getListOpname";
    static const String detailOpnameById = "detailOpnameById";

    static const String bookStockSalesOrder = "bookStockSalesOrder";
    static const String editSalesOrder = "editSalesOrder";
    static const String cancelGr = "cancelGr";

    static const String getDeliveryListSO = "getDeliveryListSO";
    static const String getDeliveryListTransfer = "getDeliveryListTransfer";
    static const String deliveryPickupSO = "deliveryPickupSO";
    static const String deliveryConfirmSO = "deliveryConfirmSO";
    static const String getListDestionTransfer = "getListDestionTransfer";
    static const String getLatestStockOpname ="getLatestStockOpname";
    static const String getBranch ="getBranch";
    static const String login ="login";

    static const String login ="login";

    static String pathGetProductById(String productId) {
        return "v2/sales/product/$productId";
    }

    static String pathUpdateCustomerById(String custId) {
        return "v2/sales/customers/$custId";
    }


    static String pathGetDetailCustomerById(String custId) {
        return "v2/sales/customers/$custId";
    }

    static String pathCreatenewVisit(String custId) {
        return "v2/sales/customers/$custId/visits";
    }

    static String pathGetVisitById(String custId, String visitId) {
        return "v2/sales/customers/$custId/visits/$visitId";
    }

    static String pathGetListVisit(String custId) {
        return "v2/sales/customers/$custId/visits";
    }

    static String pathArchiveCustomer(String custId) {
        return "v2/sales/customers/$custId/archive";
    }

    static String pathUnarchiveCustomer(String custId) {
        return "v2/sales/customers/$custId/unarchive";
    }

    static String pathCheckinVisit(String custId) {
        return "v2/sales/customers/$custId/visits/check-in";
    }

    static String pathCheckinDeliveryTransfer(String custId) {
        return "v2/sales/operation-units/$custId/check-in";
    }

    static String pathCheckinDeliverySalesOrder(String custId) {
        return "v2/sales/sales-orders/$custId/check-in";
    }

    static String pathDetailPurchaseById(String purchaseId){
        return "v2/sales/purchase-orders/$purchaseId";
    }

    static String pathCancelPurchase(String purchaseId) {
        return "v2/sales/purchase-orders/$purchaseId/cancel";
    }

    static String pathUpdateManufactureById(String manId) {
        return "v2/sales/manufactures/$manId";
    }

    static String pathGetDetailManufactureById(String manId) {
        return "v2/sales/manufactures/$manId";
    }

    static String pathGetListStockByUnit(String unit) {
        return "v2/sales/operation-units/$unit/latest-stocks";
    }
    static String pathGetListManufactureOutput(String inputId) {
        return "v2/sales/product-categories/$inputId/manufacture-output";
    }

    static String pathUpdateTerminateById(String terminateId) {
        return "v2/sales/stock-disposals/$terminateId";
    }

    static String pathGetDetailTerminateById(String terminateId) {
        return "v2/sales/stock-disposals/$terminateId";
    }

    static String pathDetailOrderById(String orderId){
        return "v2/sales/sales-orders/$orderId";
    }

    static String pathCancelOrder(String orderId) {
        return "v2/sales/sales-orders/$orderId/cancel";
    }

    static String pathCancelBookedOrder(String orderId) {
        return "v2/sales/sales-orders/$orderId/book-stock/cancel";
    }

    static String pathGetTransferDetailById(String transferId) {
        return "v2/sales/internal-transfers/$transferId";
    }

    static String pathUpdateTransferByid(String transferId) {
        return "v2/sales/internal-transfers/$transferId";
    }

    static String pathTransferBookStock(String transferId) {
        return "v2/sales/internal-transfers/$transferId/book-stock";
    }

    static String pathTransferCancelBookStock(String transferId) {
        return "v2/sales/internal-transfers/$transferId/book-stock/cancel";
    }

    static String pathTransferReadyToDeliver(String transferId) {
        return "v2/sales/internal-transfers/$transferId/ready-to-deliver//cancel";
    }

    static String pathTransferCancel(String transferId) {
        return "v2/sales/internal-transfers/$transferId/cancel";
    }

    static String pathTransferSetDriver(String transferId) {
        return "v2/sales/internal-transfers/$transferId/set-driver";
    }

    static String pathTransferPickUp(String transferId) {
        return "v2/sales/internal-transfers/$transferId/pick-up";
    }

    static String pathTransferConfirmed(String transferId) {
        return "v2/sales/internal-transfers/$transferId/delivered";
    }

    static String pathEditPurchase(String purchaseId) {
        return "v2/sales/purchase-orders/$purchaseId";
    }

    static String pathUpdateOpnameById(String opnameId) {
        return "v2/sales/stock-opnames/$opnameId";
    }

    static String pathGetDetailOpanameById(String opnameId) {
        return "v2/sales/stock-opnames/$opnameId";
    }

    static String pathBookStock(String orderId) {
        return "v2/sales/sales-orders/$orderId/book-stock";
    }

    static String pathOrderSetDriver(String orderId) {
        return "v2/sales/sales-orders/$orderId/set-driver";
    }

    static String pathEditSalesOrder(String orderId) {
        return "v2/sales/sales-orders/$orderId";
    }

    static String pathCancelGr(String goodsReceivedId) {
        return "v2/sales/goods-received/$goodsReceivedId/cancel";
    }

    static String pathDetailGrByPurchaseById(String goodReceiveId){
        return "v2/sales/goods-received/$goodReceiveId";
    }

    static String pathDeliverySOPickup(String orderId) {
        return "v2//sales/sales-orders/$orderId/pick-up";
    }

    static String pathDeliveryConfirmSO(String orderId) {
        return "v2/sales/sales-orders/$orderId/deliver";
    }
    static String pathDeliveryRejectSO(String orderId) {
        return "v2/sales/sales-orders/$orderId/return-product";
    }
    static String pathCancelDeliveryOrder(String orderId) {
        return "v2/sales/sales-orders/$orderId/ready-to-deliver/cancel";
    }
}
