import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Blocs/auth_bloc.dart';
import 'package:flutter_map_booking/Components/ink_well_custom.dart';
import 'package:flutter_map_booking/Networking/auth_api_provider.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 6;

  bool hasError = false;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    Map<String, String> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: blackColor,),
          onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoute.loginScreen),
        ),
      ),
      body: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0.0, 20, 0.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: Text('Phone Verification',style: heading35Black,),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 0.0),
                      child: Text('Enter your OTP code hear'),
                    ),
                    Center(
                      child: PinCodeTextField(
                        autofocus: true,
                        controller: controller,
                        hideCharacter: false,
                        highlight: true,
                        highlightColor: secondary,
                        defaultBorderColor: blackColor,
                        hasTextBorderColor: primaryColor,
                        maxLength: pinLength,
                        hasError: hasError,
                        pinBoxWidth: 40,
                        maskCharacter: "*",
                        onTextChanged: (text) {
                          setState(() {
                            hasError = false;
                          });
                        },
                        onDone: (text){
                          print("DONE $text");
                        },
                        wrapAlignment: WrapAlignment.start,
                        pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                        pinTextStyle: heading35Black,
                        pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                      ),
                    ),
                    SizedBox(height: 20),
                    ButtonTheme(
                      height: 50.0,
                      minWidth: MediaQuery.of(context).size.width-50,
                      child: RaisedButton.icon(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                        elevation: 0.0,
                        color: primaryColor,
                        icon: new Text(''),
                        label: new Text('VERIFY NOW', style: headingWhite,),
                        onPressed: () async{
//                          Navigator.of(context).pushReplacementNamed(AppRoute.introScreen);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Center(
                                        child: SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 4,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                          if (args["verificationType"] == "login") {
                            print(controller.text.trim());
                            AuthApiResponse response = await Provider.of<AuthBloc>(context,listen: false).signInVerification(
                                phoneNumber: args['phoneNumber'],
                                token: controller.text.trim());
                            if (response.success) {
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/authScreen'));
                            } else {
                              Navigator.pop(context);   //close current progress-bar dialog
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Center(
                                            child: Text(response.message),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }
                          } else {
                            AuthApiResponse response = await Provider.of<AuthBloc>(context,listen: false).registrationVerification(
                                phoneNumber: "0${args['phoneNumber']}",
                                token: controller.text.trim());
                            if (response.success) {
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/authScreen'));
                            } else {
                              Navigator.pop(context);  //close current progress-bar dialog
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Center(
                                            child: Text(response.message),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new InkWell(
                              onTap: () => Navigator.of(context).pushNamed(AppRoute.loginScreen),
                              child: new Text("I didn't get a code",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ]
              ),
            ),
          )
      ),
    );
  }
}
