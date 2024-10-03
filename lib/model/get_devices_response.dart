class GetDevicesResponse {
  String status;
  List<Device> devices;

  GetDevicesResponse({
    required this.status,
    required this.devices,
  });

  factory GetDevicesResponse.fromJson(Map<String, dynamic> json) =>
      GetDevicesResponse(
        status: json["status"],
        devices:
            List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
      };
}

class Device {
  String deviceName;
  String macAddress;

  Device({
    required this.deviceName,
    required this.macAddress,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        deviceName: json["device_name"],
        macAddress: json["mac_address"],
      );

  Map<String, dynamic> toJson() => {
        "device_name": deviceName,
        "mac_address": macAddress,
      };
}
