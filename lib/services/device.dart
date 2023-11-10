import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEDevice {
  static final FlutterReactiveBle _bleInst = FlutterReactiveBle();

  static final Uuid _devParamServiceId =
      Uuid.parse('54f14985-0229-4e49-b054-18337e1f05d8');
  static final Uuid _pressureCharId =
      Uuid.parse('40650939-41cc-436c-959e-7f628d9720ee');
  static final Uuid _batteryPercentCharId =
      Uuid.parse('790cbc53-3aa9-471b-bbf2-e67cefaf5c6a');

  static final StreamController<Set<BLEDevice>> _streamController =
      StreamController.broadcast();

  static final Set<BLEDevice> currentDevices = {};
  static void _addConnectedDevice(BLEDevice device) {
    currentDevices.add(device);
    _streamController.add(currentDevices.toSet());
  }

  static void _removeConnectedDevice(BLEDevice device) {
    currentDevices.remove(device);
    _streamController.add(currentDevices.toSet());
  }

  static Stream<Set<BLEDevice>> get currentDevicesStream {
    return _streamController.stream;
  }

  static Future<void> disconnectAll() async {
    await Future.wait(
        [for (BLEDevice device in currentDevices) device.disconnect()]);
  }

  final DiscoveredDevice _device;
  final QualifiedCharacteristic _pressureCharacteristic,
      _batteryPercentCharacteristic;

  bool isConnected = false;
  StreamSubscription<ConnectionStateUpdate>? _connectionStateStreamSub;

  BLEDevice(this._device)
      : _pressureCharacteristic = QualifiedCharacteristic(
          deviceId: _device.id,
          serviceId: _devParamServiceId,
          characteristicId: _pressureCharId,
        ),
        _batteryPercentCharacteristic = QualifiedCharacteristic(
          deviceId: _device.id,
          serviceId: _devParamServiceId,
          characteristicId: _batteryPercentCharId,
        );

  String get id => _device.id;
  int get rssi => _device.rssi;
  String get name => _device.name;

  Future<void> connect() async {
    //See https://pub.dev/packages/flutter_reactive_ble#establishing-connection for why [connectToAdvertisingDevice] was used
    final connectionStream = _bleInst.connectToAdvertisingDevice(
      id: _device.id,
      withServices: const [],
      prescanDuration: const Duration(seconds: 20),
    );

    final Completer<void> isConnectedComplete = Completer();
    _connectionStateStreamSub = connectionStream.listen((event) {
      if (event.connectionState == DeviceConnectionState.connected) {
        isConnected = true;

        if (!isConnectedComplete.isCompleted) {
          isConnectedComplete.complete();
        }
      } else if (event.connectionState == DeviceConnectionState.disconnected) {
        isConnected = false;
      }
    });

    await isConnectedComplete.future;
    _addConnectedDevice(this);
  }

  Future<void> disconnect() async {
    _connectionStateStreamSub?.cancel();
    _removeConnectedDevice(this);
  }

  double _bytesToFloat(List<int> byteData) {
    assert(byteData.length == 4);

    final Uint8List data = Uint8List.fromList(byteData);
    return data.buffer.asFloat32List(0, 1).first;
  }

  Stream<double> pressureStream() {
    return _bleInst
        .subscribeToCharacteristic(_pressureCharacteristic)
        .map(_bytesToFloat);
  }

  Future<int> getBatteryPercentage() async {
    final List<int> data =
        await _bleInst.readCharacteristic(_batteryPercentCharacteristic);

    assert(data.length == 1);

    return data.first;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! BLEDevice) {
      return false;
    }

    return _device.id == other._device.id;
  }

  @override
  int get hashCode => _device.id.hashCode;
}

extension BoolToInt on bool {
  int toInt() {
    return this ? 1 : 0;
  }
}

extension IntToBool on int {
  bool toBool() {
    return this != 0;
  }
}
