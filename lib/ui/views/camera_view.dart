import 'package:surveypptik/viewmodels/camera_view_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:stacked/stacked.dart';

// import flutter services
import 'package:flutter/services.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() {
    return _CameraViewState();
  }
}

class _CameraViewState extends State {
  @override
  Widget build(BuildContext context) {
    
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    return ViewModelBuilder<CameraViewModel>.reactive(
      viewModelBuilder: () => CameraViewModel(),
      onModelReady: (model) => model.initModel(mounted),
      builder: (context, model, child) => Scaffold(
        body: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _cameraPreviewWidget(model.controller),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _cameraTogglesRowWidget(model, mounted),
                    _captureControlRowWidget(context, model),
                    Spacer()
                  ],
                ),
                SizedBox(height: 20.0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget(CameraController controller) {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context, CameraViewModel model) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              child: Icon(Icons.camera),
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                model.onCapturePressed(context);
              },
            )
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget(CameraViewModel model, bool mounted) {
    if (model.cameras == null || model.cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = model.cameras[model.selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: () {
              model.onSwitchCamera(mounted);
            },
            icon: Icon(_getCameraLensIcon(lensDirection)),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }
}
