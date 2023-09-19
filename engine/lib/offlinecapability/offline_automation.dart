// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages, avoid_print

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../dao/dao_impl.dart';
import '../request/service.dart';
import '../request/transport/interface/response_listener.dart';
import '../request/transport/interface/service_body.dart';
import '../util/interface/schedule_listener.dart';
import '../util/scheduler.dart';
import 'offline.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class OfflineAutomation {
    Map<DaoImpl, ServicePeripheral?> registered = {};

    OfflineAutomation put(DaoImpl persistance) {
        registered[persistance] = null;
        return this;
    }

    OfflineAutomation putWithRequest(DaoImpl persistance, ServicePeripheral servicePeripheral) {
        registered[persistance] = servicePeripheral;
        return this;
    }

    Future<List> _getRecords(DaoImpl daoImpl) async {
        return await daoImpl.getRecords('idOffline');
    }

    Future<T> _getRecord<T extends Offline>(DaoImpl daoImpl, int idOffline) async {
        return await daoImpl.queryForModel(daoImpl.instance, 'SELECT * FROM ${daoImpl.tableName} WHERE idOffline = ?', [idOffline]);
    }

    void _deleteByExpiredDateAndFlag(Offline record, DaoImpl daoImpl) {
        try {
            int expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(record.expiredDate!).millisecondsSinceEpoch;

            if (DateTime.now().millisecondsSinceEpoch >= expiredDate && record.flag == 1) {
                daoImpl.delete("idOffline = ?", [record.idOffline.toString()]);
            }
        } on Exception catch(e, stacktrace) {
            print(stacktrace);
        }
    }

    void _deleteByExpiredDate(Offline record, DaoImpl daoImpl) {
        try {
            int expiredDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(record.expiredDate!).millisecondsSinceEpoch;

            if (DateTime.now().millisecondsSinceEpoch >= expiredDate) {
                daoImpl.delete("idOffline = ?", [record.idOffline.toString()]);
            }
        } on Exception catch(e, stacktrace) {
            print(stacktrace);
        }
    }

    Future<int?> _updateFlag<T extends Offline>(DaoImpl daoImpl, int idOffline) async {
        dynamic data = await daoImpl.queryForModel(daoImpl.instance, "SELECT * FROM ${daoImpl.tableName} WHERE idOffline = ?", [idOffline]);
        data.flag = 1;

        return await daoImpl.save(data);
    }

    void launch() async {
        await Scheduler()
            .listener(SchedulerListener(
            onTick: (packet) {
                registered.forEach((key, value) async {
                    for (Offline record in await _getRecords(key)) {
                        if (value == null) {
                            _deleteByExpiredDate(record, key);
                        } else  {
                            if (record.flag == 0) {
                                ServiceBody serviceBody = value.getRequestBody();
                                _getRecord(key, record.idOffline!).then((result) async {
                                    value.push(
                                        serviceBody.getServiceName(result),
                                        Get.context!,
                                        await serviceBody.body(result, value.getExtras()),
                                        ResponseListener(
                                            onResponseDone: (code, message, body, id, packet) async {
                                                int? updateStatus = await _updateFlag(key, record.idOffline!);
                                                if (updateStatus != null && updateStatus > 0) {
                                                    _deleteByExpiredDateAndFlag(await _getRecord(key, record.idOffline!), key);
                                                }
                                            },
                                            onResponseFail: (code, message, body, id, packet) {},
                                            onResponseError: (exception, stacktrace, id, packet) {},
                                            onTokenInvalid: () {}
                                        )
                                    );
                                });
                            } else {
                                _deleteByExpiredDateAndFlag(record, key);
                            }
                        }
                    }
                });

                return true;
            },
            onTickDone: (packet) {},
            onTickFail: (packet) {}))
            .always(true)
            .run(const Duration(minutes: 1));
    }
}