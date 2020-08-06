
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:surveypptik/ui/widgets/button_widget.dart';
import 'package:surveypptik/ui/widgets/text_field_widget.dart';
import 'package:surveypptik/viewmodels/edit_password_view_model.dart';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
//import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:stacked/stacked.dart';

// import flutter services
import 'package:flutter/services.dart';

class EditPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    return ViewModelBuilder<EditPasswordViewModel>.reactive(
      viewModelBuilder: () =>EditPasswordViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          elevation: 0.0,
          title: Text('Change Password'),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: model.busy,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    verticalSpaceLarge,
                    TextFieldWidget(
                      hintText: 'Current Password',
                      icon: Icons.lock,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      textFieldController: model.currentPasswordController,
                    ),
                    verticalSpaceSmall,
                    TextFieldWidget(
                      hintText: 'New Password',
                      icon: Icons.vpn_key,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      textFieldController: model.newPasswordController,
                    ),
                    verticalSpaceSmall,
                    TextFieldWidget(
                      hintText: 'New Password Confirmation',
                      icon: Icons.vpn_key,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      textFieldController: model.confirmationPasswordController,
                    ),
                    verticalSpaceLarge,
                    ButtonWidget(
                      title: 'Save',
                      onPressedFunction: () {
                        // model.register(context);
                        model.onUpdtePassword(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
