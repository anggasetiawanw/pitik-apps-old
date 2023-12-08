// ignore_for_file: slash_for_doc_comments

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class ListApi {
    static const String auth = "auth";
    static const String addDevice = "addDevice";
    static const String profile = "profile";
    static const String changePassword = "changePassword";
    static const String getHomeData = "getHomeData";
    static const String createCoopInfrastructure = "createCoopInfrastructure";
    static const String modifyInfrastructure = "modifyInfrastructure";
    static const String getDetailRoom = "getDetailRoom";
    static const String getCoops = "getCoops";
    static const String getDetailCoop = "getDetailCoop";
    static const String registerDevice = "registerDevice";
    static const String uploadImage = "uploadImage";
    static const String getApproval = "getApproval";
    static const String countUnreadNotifications = "countUnreadNotifications";
    static const String readAllNotifications = "readAllNotifications";
    static const String notifications = "notifications";
    static const String updateNotification = "updateNotification";

    // api SMART MONITOR
    static const String getDetailSmartMonitoring = "getDetailSmartMonitoring";
    static const String modifyDevice = "modifyDevice";
    static const String getLatestCondition = "getLatestCondition";
    static const String getHistoricalData = "getHistoricalData";
    static const String getListBuilding = "getListBuilding";
    static const String getRealTimeHistorical = "realTime";
    static const String getRealTimeHistoricalForSmartController = "realTimeSmartController";
    static const String getSensorPosition = "sensorPosition";

    // api SMART CAMERA
    static const String getSmartCameraListDay = "getSmartCameraListDay";
    static const String getRecordImages = "getRecordImages";
    static const String getListDataCamera = "getListDataCamera";
    static const String takePictureSmartCamera = "takePictureSmartCamera";

    // api SMART CONTROLLER
    static const String getFloorList = "getFloor";
    static const String getDetailSmartController = "getDetailSmartController";
    static const String getDataGrowthDay = "getDataGrowthDay";
    static const String setController = "setController";
    static const String getFanData = "getFanData";
    static const String getFanDetail = "getFanDetail";
    static const String getCoolerData = "getCoolerData";

    // api SMART SCALE
    static const String getListHistoryScale = "getListHistoryScale";
    static const String getSmartScaleDetail = "getSmartScaleDetail";
    static const String saveSmartScale = "saveSmartScale";
    static const String updateSmartScale = "updateSmartScale";
    static const String getListSmartScale = "getListSmartScale";

    // api PRODUCT REPORT
    static const String getSapronak = "getSapronak";
    static const String getProductById = "getProductById";
    static const String getListPurchaseRequest = "getListPurchaseRequest";
    static const String getListPurchaseRequestForCoopRest = "getListPurchaseRequestForCoopRest";
    static const String getListPurchaseOrder = "getListPurchaseOrder";
    static const String getListPurchaseOrderForCoopRest = "getListPurchaseOrderForCoopRest";
    static const String getReceiveProcurement = "getReceiveProcurement";
    static const String getRequestDoc = "getRequestDoc";
    static const String approveRequestChickin = "approveRequestChickin";
    static const String saveRequestChickin = "saveRequestChickin";
    static const String getDetailRequest = "getDetailRequest";
    static const String getRequestChickinDetail = "getRequestChickinDetail";
    static const String getProducts = "getProducts";
    static const String searchOvkUnit = "searchOvkUnit";
    static const String saveOrderRequest = "purchaseRequest";
    static const String saveOrderRequestForCoopRest = "purchaseRequestForCoopRest";
    static const String saveTransferRequest = "transferRequest";
    static const String updateOrderOrTransferRequest = "purchaseOrTransferRequestUpdate";
    static const String cancelOrder = "cancelOrder";
    static const String rejectOrder = "rejectOrder";
    static const String approveOrder = "approvalOrder";
    static const String getListTransferSend = "getTransferSend";
    static const String getListTransferReceived = "getTransferReceived";
    static const String getTransferDetail = "getTransferDetail";
    static const String getStocks = "getStocks";
    static const String getStocksSummary = "getStocksSummary";
    static const String getDetailReceived = "getDetailReceived";
    static const String createReceiptOrder = "createReceiptOrder";
    static const String createReceiptTransfer = "createReceiptTransfer";

    // api FARMING PERFORMANCE
    static const String getPerformanceMonitoring = "getPerformanceMonitoring";
    static const String getMonitoringByVariable = "getMonitoringByVariable";
    static const String getAllDataMonitoring = "getAllDataMonitoring";
    static const String getDateMonitoring = "getDateMonitoring";
    static const String getDetailMonitoring = "getDetailMonitoring";
    static const String getListHarvestRealization = "getListHarvestRealization";
    static const String updateRequestChickin = "updateRequestChickin";
    static const String getLeftOver = "getLeftOver";
    static const String getAdjustment = "getAdjustment";
    static const String adjustClosing = "adjustClosing";
    
    // api HARVEST
    static const String getSubmitsHarvest = "getSubmitsHarvest";
    static const String getDealsHarvest = "getDealsHarvest";
    static const String getRealizationHarvest = "getRealizationHarvest";
    static const String getDetailHarvest = "getDetailHarvest";
    static const String approveOrRejectHarvest = "approveOrRejectHarvest";
    static const String addHarvestRequest = "addHarvestRequest";
    static const String harvestDealCancelled = "harvestDealCancelled";
    static const String saveHarvestRealization = "saveHarvestRealization";
    static const String updateHarvestRealization = "updateHarvestRealization";

    // api TASK
    static const String getDailyReport = "getDailyReport";
    static const String getDetailDailyReport = "getDetailDailyReport";
    static const String addReport = "addReport";
    static const String reviewReport = "reviewReport";

    static String pathChangePassword() {
        return "v2/auth/reset-password";
    }

    static String pathDetailRoom(String coopId, String roomId) {
        return "v2/b2b/farm-infrastructure/coops/$coopId/rooms/$roomId";
    }

    static String pathListCoops() {
        return "v2/b2b/farm-infrastructure/coops";
    }

    static String pathDetailCoop(String coopId) {
        return "v2/b2b/farm-infrastructure/coops/$coopId";
    }

    static String pathModifyInfrastructure(String coopId) {
        return "v2/b2b/farm-infrastructure/coops/$coopId";
    }

    static String pathDetailSmartMonitoring(String deviceId) {
        return "v2/b2b/iot-devices/smart-monitoring/$deviceId";
    }

    static String pathLatestCondition(String deviceId) {
        return "v2/b2b/iot-devices/smart-monitoring/$deviceId/latest-conditions";
    }

    static String pathModifyDevice(String deviceType, String deviceId, String action) {
        return "v2/b2b/iot-devices/$deviceType/$deviceId/$action";
    }

    static String pathHistoricalData(String deviceId) {
        return "v2/b2b/iot-devices/smart-monitoring/$deviceId/historical";
    }

    static String pathRegisterDevice(String deviceType) {
        return "v2/b2b/iot-devices/$deviceType/register";
    }

    static String pathCameraImages(String coopId, String cameraId) {
        return "v2/b2b/iot-devices/smart-camera/$coopId/records/$cameraId";
    }

    static String pathListCamera(String coopId, String roomId) {
        return "v2/b2b/iot-devices/smart-camera/$coopId/records?roomId=$roomId";
    }

    static String pathTakeImage(String coopId) {
        return "v2/b2b/iot-devices/smart-camera/jobs/$coopId";
    }

    static String pathDetailSmartController(String basePath, String coopCodeId, String deviceId) {
        return "$basePath?coopId=$coopCodeId&deviceId=$deviceId";
    }

    static String pathDeviceData(String basePath, String device, String coopCodeId, String deviceId) {
        return "$basePath$device?coopId=$coopCodeId&deviceId=$deviceId";
    }

    static String pathDetailFanData(String basePath, String device, String coopCodeId, String deviceId, String id) {
        return "$basePath$device/detail?coopId=$coopCodeId&deviceId=$deviceId&id=$id";
    }

    static String pathSetController(String basePath, String device, String coopCodeId, {bool forPitikConnect = true, String idForNonPitikConnect = ''}) {
        if (forPitikConnect) {
        return "$basePath$device/$coopCodeId";
        } else {
        return '$basePath$device/$idForNonPitikConnect';
        }
    }

    static String pathSmartScaleForDetailAndUpdate(String weighingId) {
        return "v2/b2b/weighing/$weighingId";
    }

    static String pathGetProductById(String productId) {
        return "v2/sales/product/$productId";
    }

    static String pathGetSapronakByType(String farmingCycleId, String type) {
        return 'v2/farming-cycles/$farmingCycleId/purchase-orders/$type';
    }

    static String pathGetRequestDocByFarmingId(String farmingCycleId) {
        return 'v2/farming-cycles/$farmingCycleId/doc-in';
    }

    static String pathGetRequestDetail(String requestId) {
        return 'v2/purchase-requests/$requestId';
    }

    static String pathGetTransferRequestDetail(String requestId) {
        return 'v2/transfer-requests/$requestId';
    }

    static String pathGetRequestChickinDetail(String requestId) {
        return "v2/chick-in-requests/$requestId";
    }

    static String pathApproveRequestChickinDetail(String requestId) {
        return "v2/chick-in-requests/$requestId/approve";
    }

    static String pathFeedStocks(String farmingCycle) {
        return "v2/feedstocks/$farmingCycle/summaries";
    }

    static String pathOvkStocks(String farmingCycle) {
        return "v2/ovkstocks/$farmingCycle/summaries";
    }

    static String pathFeedSummaryStocks(String farmingCycle) {
        return "v2/feedstocks/$farmingCycle/summaries-by-type";
    }

    static String pathOvkSummaryStocks(String farmingCycle) {
        return "v2/ovkstocks/$farmingCycle/summaries-by-type";
    }

    static String pathDailyReport(String coopId) {
        return "v2/farming-cycles/$coopId/daily-reports";
    }

    static String pathDailyReportDetail(String coopId, String ticketId) {
        return "v2/farming-cycles/$coopId/daily-reports/$ticketId";
    }

    static String pathAddReport(String coopId, String ticketId) {
        return "v2/farming-cycles/$coopId/daily-reports/$ticketId";
    }
    
    static String pathReviewReport(String coopId, String ticketId) {
        return "v2/farming-cycles/$coopId/daily-reports/$ticketId/mark-as-reviewed";
    }
}
