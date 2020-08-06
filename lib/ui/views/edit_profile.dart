import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:surveypptik/ui/widgets/button_widget.dart';
import 'package:surveypptik/ui/widgets/text_filed_on_changed_widget.dart';
import 'package:surveypptik/viewmodels/edit_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
// import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:stacked/stacked.dart';

// import flutter services
import 'package:flutter/services.dart';

class EditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () =>EditProfileViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          elevation: 0.0,
          title: Text('Edit Profile'),
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
                    TextFieldOnChangedWidget(
                      hintText: 'Registration Code',
                      icon: Icons.code,
                      keyboardType: TextInputType.text,
                      isPassword: false,
                      onChanged: (value) {
                        if (value != null && value.toString().isNotEmpty) {
                          model.company = value;
                          model.getCompanyUnit(value);
                        }
                      },
                    ),
                    Visibility(
                      visible: model.changeVisibility(),
                      child: verticalSpaceSmall,
                    ),
                    Visibility(
                      visible: model.changeVisibility(),
                      child: Container(
                        padding: fieldPadding,
                        width: screenWidthPercent(
                          context,
                          multipleBy: 0.9,
                        ),
                        height: fieldHeight,
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Text('Choose Unit'),
                          value: model.unitSelected,
                          items: model.units == null
                              ? null
                              : model.units.map(
                                  (value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  },
                                ).toList(),
                          onChanged: (value) {
                            model.onUnitChanged(value);
                          },
                        ),
                      ),
                    ),
                    verticalSpaceLarge,
                    ButtonWidget(
                      title: 'Save',
                      onPressedFunction: () {
                        // model.register(context);
                        model.updateCompanyUnit(context);
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
