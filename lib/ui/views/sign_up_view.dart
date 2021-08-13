import 'dart:io';

import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:surveypptik/ui/widgets/button_widget.dart';
import 'package:surveypptik/ui/widgets/text_field_widget.dart';
import 'package:surveypptik/ui/widgets/text_filed_on_changed_widget.dart';
import 'package:surveypptik/viewmodels/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
//import 'package:provider_architecture/provider_architecture.dart';
import 'package:stacked/stacked.dart';

// import flutter services
import 'package:flutter/services.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool eulaVal = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    Provider.of<SignUpViewModel>(context,listen: false).getAreas();
//  context.read<SignUpViewModel>().getAreas();
  }

  @override
  Widget build(BuildContext context) {
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      //  onModelReady: (model) => model.onReady(),
      builder: (context, model, child) => Scaffold(
        body: LoadingOverlay(
          isLoading: model.busy,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      verticalSpaceMassiveSignup,
                      Text(
                        'Sign Up',
                        style: titleTextStyle,
                      ),
                      verticalSpaceMassiveSignup,
                      TextFieldWidget(
                        hintText: 'Name',
                        icon: Icons.person,
                        keyboardType: TextInputType.text,
                        isPassword: false,
                        textFieldController: model.nameController,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hintText: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: false,
                        textFieldController: model.emailController,
                      ),
                      verticalSpaceSmall,
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
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hintText: 'No KTP/ NISN /NIP',
                        icon: Icons.format_list_numbered,
                        keyboardType: TextInputType.text,
                        isPassword: false,
                        textFieldController: model.idCardController,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hintText: 'Password',
                        icon: Icons.lock,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: true,
                        textFieldController: model.passwordController,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hintText: 'No Handphone',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        isPassword: false,
                        textFieldController: model.phoneNumberController,
                      ),
                      verticalSpaceSmall,
                      InkWell(
                        onTap: () async {
                          await model.cameraView();
                        },
                        child: Container(
                          padding: fieldPadding,
                          width: screenWidthPercent(
                            context,
                            multipleBy: 0.83,
                          ),
                          height: screenHeightPercent(
                            context,
                            multipleBy: 0.25,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: model.isPathNull() == false
                              ? Center(
                                  child: Text(
                                    'Upload KTP/ID Card',
                                    style: textButtonTextStyle,
                                  ),
                                )
                              :Image.file(File(model.imagePath),fit: BoxFit.cover,),
                          // FittedBox(
                          //         child: Image.file(File(model.imagePath)),
                          //         fit: BoxFit.fitWidth,
                                ),
                        // ),
                      ),
                      verticalSpaceMedium,
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: eulaVal,
                            onChanged: (bool value) {
                              setState(() {
                                eulaVal = value;
                              });
                              model.onChangeEula(value);
                              print(eulaVal);
                              print("mode ${model.eula}");
                            },
                          ),
                          InkWell(
                            child: Text("Saya Paham dan setuju dng  isi EULA"),
                            onTap: () {
                              model.showEula(context);
                            },
                          )
                        ],
                      ),
                      // verticalSpaceLarge,
                      verticalSpaceMassiveSignup,
                      ButtonWidget(
                        title: 'Sign Up',
                        onPressedFunction: () {
                          model.register(context);
                        },
                      ),
                      verticalSpaceMedium,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
