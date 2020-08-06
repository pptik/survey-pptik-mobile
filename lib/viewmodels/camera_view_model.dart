import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class CameraViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final StorageService _storageService = locator<StorageService>();

  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  String date = '';

  void initModel(bool mounted) {
    getAvailableCamera(mounted);
  }
  
  void getAvailableCamera(bool mounted) {
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        selectedCameraIdx = 1;
        setBusy(false);

        _initCameraController(cameras[selectedCameraIdx], mounted)
            .then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
    setBusy(false);
  }

  Future _initCameraController(
      CameraDescription cameraDescription, bool mounted) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.max);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setBusy(false);
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showCameraException(e);
    }

    if (mounted) {
      setBusy(false);
    }
  }

  void showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }

  void onCapturePressed(context) async {
      final guid = await _storageService.getString(K_GUID);

    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      final directory = await getExternalStorageDirectory();
      // Attempt to take a picture and log where it's been saved
      final dateFormat = formatDate();
      final fileName = '${dateFormat.toString()}-PPTIK.png';
      final path = join(
        // In this example, store the picture in the temp directory. Find
        // the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path,
      '${dateFormat.toString()}-PPTIK.png',
      );
      print("eksplorer ${directory.path}");
      await controller.takePicture(path);

      _navigationService.popWithValue('$path#$fileName');
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void onSwitchCamera(bool mounted) {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera, mounted);
  }

  String formatDate() {
    DateFormat dateFormat = DateFormat("MM_dd_yyyy_HH_mm_ss");
    return dateFormat.format(DateTime.now());
  }
}
