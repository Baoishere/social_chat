import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class Permissions {
  static Future<bool> cameraMicrophoneAndStoragePermissionGranted() async {
    PermissionStatus cameraPermissionStatus = await getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await getMicrophonePermission();
    PermissionStatus storagePermissionStatus = await getStoragePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted &&
        storagePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermission(cameraPermissionStatus,
          microphonePermissionStatus, storagePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status == PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.camera].request();
      return statuses[Permission.camera] ?? PermissionStatus.limited;
    } else {
      print('TRẠNG THÁI CAMERA $status');
      return status;
    }
  }

  static Future<PermissionStatus> getMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status == PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.microphone].request();
      return statuses[Permission.microphone] ?? PermissionStatus.limited;
    } else {
      print('TRẠNG THÁI TAI NGHE $status');
      return status;
    }
  }

  static Future<PermissionStatus> getStoragePermission() async {
    var status = await Permission.storage.status;
    if (status == PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      return statuses[Permission.storage] ?? PermissionStatus.limited;
    } else {
      print('TRẠNG THÁI KHO LƯU TRỮ $status');
      return status;
    }
  }

  static void _handleInvalidPermission(
      PermissionStatus cameraPermissionStatus,
      PermissionStatus microphonePermissionStatus,
      PermissionStatus storagePermissionStatus) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
        code: "PERMISSION_DENIED",
        message: "Truy cập vào Camera và Micrô bị từ chối",
        details: "null",
      );
    } else if (cameraPermissionStatus == PermissionStatus.restricted &&
        microphonePermissionStatus == PermissionStatus.restricted) {
      throw new PlatformException(
        code: "PERMISSION_RESTRICTED",
        message: "Dữ liệu vị trí không có sẵn trên thiết bị",
        details: "null",
      );
    } else if (storagePermissionStatus == PermissionStatus.restricted &&
        storagePermissionStatus == PermissionStatus.restricted) {
      throw new PlatformException(
        code: "PERMISSION_RESTRICTED",
        message: "Không được phép cấp quyền lưu trữ trên thiết bị",
        details: "null",
      );
    }
  }
}
