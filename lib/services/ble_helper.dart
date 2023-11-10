import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:smart_pacifier/services/device.dart';
export 'package:flutter_reactive_ble/flutter_reactive_ble.dart' show BleStatus;

class BLE {
  static final FlutterReactiveBle _bleInst = FlutterReactiveBle();

  static const Duration _timeout = Duration(seconds: 10);

  static Stream<BleStatus> status() {
    return _bleInst.statusStream;
  }

  static Stream<BLEDevice> scan() {
    return _bleInst
        .scanForDevices(
          withServices: [
            Uuid.parse('54f14985-0229-4e49-b054-18337e1f05d8'),
          ],
        )
        .map((event) => BLEDevice(event))
        .timeout(_timeout, onTimeout: (sink) {
          sink.close();
        });
  }
}
