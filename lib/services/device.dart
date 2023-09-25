import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEDevice {
  static final FlutterReactiveBle _bleInst = FlutterReactiveBle();

  static final Uuid _pressureServiceId =
      Uuid.parse('6967741f-470f-4999-94f0-4b2f3e226789');
  static final Uuid _pressureCharId =
      Uuid.parse('10ef5208-6c49-458c-82e3-e3ef4d5ac0ec');

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
  final QualifiedCharacteristic _pressureCharacteristic;

  bool isConnected = false;
  StreamSubscription<ConnectionStateUpdate>? _connectionStateStreamSub;

  BLEDevice(this._device)
      : _pressureCharacteristic = QualifiedCharacteristic(
          deviceId: _device.id,
          serviceId: _pressureServiceId,
          characteristicId: _pressureCharId,
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