import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEDevice {
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
        ),
        _isChargingCharacteristic = QualifiedCharacteristic(
          deviceId: _device.id,
          serviceId: _devParamServiceId,
          characteristicId: _batteryChargingCharId,
        ),
        _isChargerErrorCharacteristic = QualifiedCharacteristic(
          deviceId: _device.id,
          serviceId: _devParamServiceId,
          characteristicId: _batteryChargerErrorCharId,
        );
  static final FlutterReactiveBle _bleInst = FlutterReactiveBle();

  static final Uuid _devParamServiceId =
      Uuid.parse('54f14985-0229-4e49-b054-18337e1f05d8');
  static final Uuid _pressureCharId =
      Uuid.parse('40650939-41cc-436c-959e-7f628d9720ee');
  static final Uuid _batteryPercentCharId =
      Uuid.parse('790cbc53-3aa9-471b-bbf2-e67cefaf5c6a');
  static final Uuid _batteryChargingCharId =
      Uuid.parse('a454b40e-00a2-45c1-a7fd-fd1f1ffd7dca');
  static final Uuid _batteryChargerErrorCharId =
      Uuid.parse('f31736e6-cb55-4aad-a89e-a1cd1b09ab33');

  static final StreamController<Set<BLEDevice>> _streamController =
      StreamController<Set<BLEDevice>>.broadcast();

  static final Set<BLEDevice> currentDevices = <BLEDevice>{};
  static BLEDevice? displayedDevice;

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
      <Future<void>>[
        for (BLEDevice device in currentDevices) device.disconnect(),
      ],
    );
  }

  final DiscoveredDevice _device;
  final QualifiedCharacteristic _pressureCharacteristic,
      _batteryPercentCharacteristic,
      _isChargingCharacteristic,
      _isChargerErrorCharacteristic;

  bool isConnected = false;
  StreamSubscription<ConnectionStateUpdate>? _connectionStateStreamSub;

  String get id => _device.id;
  int get rssi => _device.rssi;
  String get name => _device.name;

  Future<void> connect() async {
    //See https://pub.dev/packages/flutter_reactive_ble#establishing-connection for why [connectToAdvertisingDevice] was used
    final Stream<ConnectionStateUpdate> connectionStream =
        _bleInst.connectToDevice(
      id: _device.id,
      // withServices: const <Uuid>[],
      // prescanDuration: const Duration(seconds: 20),
    );

    final Completer<void> isConnectedComplete = Completer<void>();
    _connectionStateStreamSub =
        connectionStream.listen((ConnectionStateUpdate event) {

      if (event.connectionState == DeviceConnectionState.connected) {
        isConnected = true;

        if (!isConnectedComplete.isCompleted) {
          isConnectedComplete.complete();
        }
      } else if (event.connectionState == DeviceConnectionState.disconnected) {
        isConnected = false;
      }
    },);

    await isConnectedComplete.future;
    _addConnectedDevice(this);
    await _bleInst.requestMtu(deviceId: _device.id, mtu: 150);
  }

  Future<void> disconnect() async {
    await _connectionStateStreamSub?.cancel();
    _removeConnectedDevice(this);
  }

  // double _bytesToFloat(List<int> byteData) {
  //   assert(byteData.length == 4);

  //   final Uint8List data = Uint8List.fromList(byteData);
  //   return data.buffer.asFloat32List(0, 1).first;
  // }

  List<double> _bytesToFloatList(List<int> byteData) {
    assert(byteData.length % 4 == 0);

    final Uint8List data = Uint8List.fromList(byteData);
    return data.buffer.asFloat32List().toList(growable: false);
  }

  /// Returns a stream of pressure values one at a time
  Stream<double> pressureStream() {
    return _bleInst
        .subscribeToCharacteristic(_pressureCharacteristic)
        .expand<double>((List<int> bytes) {
          return _bytesToFloatList(bytes);
        });
  }

  Future<List<int>> getBatteryInfo() async {
    final List<int> percent =
        await _bleInst.readCharacteristic(_batteryPercentCharacteristic);

    final List<int> charging =
        await _bleInst.readCharacteristic(_isChargingCharacteristic);

    assert(percent.length == 1);

    assert(charging.length == 1);

    return <int>[percent.first, charging.first];
  }

  /// Returns true if there is an error with charging
  Future<bool> getChargerErrors() async {
    final List<int> data =
        await _bleInst.readCharacteristic(_isChargerErrorCharacteristic);

    assert(data.length == 1);

    return data.first.toBool();
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
