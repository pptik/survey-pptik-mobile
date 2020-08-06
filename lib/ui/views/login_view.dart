import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/ui/shared/shared_style.dart';
import 'package:surveypptik/ui/shared/ui_helper.dart';
import 'package:surveypptik/ui/widgets/button_widget.dart';
import 'package:surveypptik/ui/widgets/text_field_widget.dart';
import 'package:surveypptik/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
//import 'package:provider_architecture/provider_architecture.dart';
import 'package:stacked/stacked.dart';

// import flutter services
import 'package:flutter/services.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // Lock Orientation Portait Only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () =>LoginViewModel(),
      builder: (context, model, child) => Scaffold(
        body: LoadingOverlay(
          isLoading: model.busy,
          child: SafeArea(

            child: SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      verticalSpaceMassive,
                      Text(
                        'Survey PPTIK',
                        style: titleTextStyle,
                      ),
                      verticalSpaceMassive,
                      TextFieldWidget(
                        hintText: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: false,
                        textFieldController: model.emailController,
                      ),
                      verticalSpaceSmall,
                      TextFieldWidget(
                        hintText: 'Password',
                        icon: Icons.lock,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: true,
                        textFieldController: model.passwordController,
                      ),
                      verticalSpaceLarge,
                      ButtonWidget(
                        title: 'Login',
                        onPressedFunction: () {
                          model.loginAccount(context);
                        },
                      ),
                      verticalSpaceSmall,
                      Container(
                        height: 50.0,
                        child: InkWell(
                          onTap: () {
                            locator<NavigationService>()
                                .navigateTo(SignUpViewRoute);
                          },
                          child: Center(
                            child: Text('Don\'t have an account ?'),
                          ),
                        ),
                      ),
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
