import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Blocs/auth_bloc.dart';
import 'package:flutter_map_booking/Components/ink_well_custom.dart';
import 'package:flutter_map_booking/Networking/auth_api_provider.dart';
import 'package:flutter_map_booking/Screen/Login/phone_verification.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:flutter_map_booking/Components/validations.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();

  TextEditingController phoneController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: InkWellCustom(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Stack(children: <Widget>[
              Container(
                height: 250.0,
                width: double.infinity,
                color: Color(0xFF6a0dad),
              ),
              Positioned(
                bottom: 450.0,
                right: 100.0,
                child: Container(
                  height: 400.0,
                  width: 400.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200.0),
                    color: Color(0xFF8510d8),
                  ),
                ),
              ),
              Positioned(
                bottom: 500.0,
                left: 150.0,
                child: Container(
                  height: 300.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(150.0),
                    color: Color(0xFF6d00c1).withOpacity(0.5),
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.fromLTRB(32.0, 150.0, 32.0, 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                          //padding: EdgeInsets.only(top: 100.0),
                          child: new Material(
                        borderRadius: BorderRadius.circular(7.0),
                        elevation: 5.0,
                        child: new Container(
                          width: MediaQuery.of(context).size.width - 20.0,
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: new Form(
                              key: formKey,
                              child: new Container(
                                padding: EdgeInsets.all(32.0),
                                child: new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Login',
                                      style: heading35Black,
                                    ),
                                    new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                            keyboardType: TextInputType.phone,
                                            validator:
                                                validations.validateMobile,
                                            controller: phoneController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                prefixIcon: Icon(Icons.phone,
                                                    color: Color(
                                                        getColorHexFromStr(
                                                            '#550a8a')),
                                                    size: 20.0),
                                                contentPadding: EdgeInsets.only(
                                                    left: 15.0, top: 15.0),
                                                hintText: 'Phone',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: 'Quicksand'))),
                                      ],
                                    ),
                                    new ButtonTheme(
                                      height: 50.0,
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      child: RaisedButton.icon(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    15.0)),
                                        elevation: 0.0,
                                        color: primaryColor,
                                        icon: new Text(''),
                                        label: new Text(
                                          'NEXT',
                                          style: headingWhite,
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState.validate()) {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Center(
                                                          child: SizedBox(
                                                            height: 25,
                                                            width: 25,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 4,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                            submit(String phone) async {
                                              AuthApiResponse response =
                                                  await Provider.of<AuthBloc>(
                                                          context,
                                                          listen: false)
                                                      .signIn(phone);
                                              if (response.success) {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                    new MaterialPageRoute(
                                                        builder: (context) =>
                                                            PhoneVerification(),
                                                        settings: RouteSettings(
                                                            arguments: {
                                                              "phoneNumber":
                                                                  phone,
                                                              "verificationType":
                                                                  "login"
                                                            })));
                                              } else {
                                                Navigator.pop(context);
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Center(
                                                              child: Text(
                                                                  response
                                                                      .message),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }
                                            }

                                            submit("0" +
                                                "${phoneController.text.trim()}");
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      )),
                      new Container(
                        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Create new account? ",
                              style: textGrey,
                            ),
                            new InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(AppRoute.signUpScreen),
                              child: new Text(
                                "Sign Up",
                                style: textStyleActive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])
          ]),
        ),
      ),
    );
  }
}
