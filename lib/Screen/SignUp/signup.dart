import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Blocs/auth_bloc.dart';
import 'package:flutter_map_booking/Components/ink_well_custom.dart';
import 'package:flutter_map_booking/Networking/auth_api_provider.dart';
import 'package:flutter_map_booking/Screen/Login/phone_verification.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:flutter_map_booking/Components/validations.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  Validations validations = new Validations();

  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

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
                color: Color(0xFF6d00c1),
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
                    color: Color(0xFF6A0DAD).withOpacity(0.5),
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.fromLTRB(32.0, 100.0, 32.0, 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        //padding: EdgeInsets.only(top: 100.0),
                        child: new Material(
                          borderRadius: BorderRadius.circular(15.0),
                          elevation: 5.0,
                          child: new Container(
                            width: MediaQuery.of(context).size.width - 20.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40.0)),
                            child: new Form(
                                key: formKey,
                                child: new Container(
                                  padding: EdgeInsets.all(32.0),
                                  child: new Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Sign up',
                                        style: heading35Black,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 30.0),
                                      ),
                                      new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator:
                                                validations.validateEmail,
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              prefixIcon: Icon(Icons.email,
                                                  color: Color(
                                                    getColorHexFromStr(
                                                        '#550a8a'),
                                                  ),
                                                  size: 20.0),
                                              contentPadding: EdgeInsets.only(
                                                  left: 15.0, top: 15.0),
                                              hintText: 'Email',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand'),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 30.0),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.phone,
                                            validator:
                                                validations.validateMobile,
                                            controller: phoneController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              prefixIcon: Icon(Icons.phone,
                                                  color: Color(
                                                    getColorHexFromStr(
                                                        '#550a8a'),
                                                  ),
                                                  size: 20.0),
                                              contentPadding: EdgeInsets.only(
                                                  left: 15.0, top: 15.0),
                                              hintText: 'Phone',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand'),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 30.0),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            validator: validations.validateName,
                                            controller: firstNameController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              prefixIcon: Icon(Icons.person,
                                                  color: Color(
                                                    getColorHexFromStr(
                                                        '#550a8a'),
                                                  ),
                                                  size: 20.0),
                                              contentPadding: EdgeInsets.only(
                                                  left: 15.0, top: 15.0),
                                              hintText: 'First Name',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand'),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 30.0),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            validator: validations.validateName,
                                            controller: lastNameController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              prefixIcon: Icon(Icons.person,
                                                  color: Color(
                                                    getColorHexFromStr(
                                                        '#550a8a'),
                                                  ),
                                                  size: 20.0),
                                              contentPadding: EdgeInsets.only(
                                                  left: 15.0, top: 15.0),
                                              hintText: 'Last Name',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand'),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 30.0),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            validator:
                                                validations.validatePassword,
                                            controller: passwordController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              prefixIcon: Icon(Icons.lock,
                                                  color: Color(
                                                    getColorHexFromStr(
                                                        '#550a8a'),
                                                  ),
                                                  size: 20.0),
                                              contentPadding: EdgeInsets.only(
                                                  left: 15.0, top: 15.0),
                                              hintText: 'Password',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Quicksand'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      new Container(
                                          child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            child: new Text(
                                              "Forgot Password ?",
                                              style: textStyleActive,
                                            ),
                                          ),
                                        ],
                                      )),
                                      new ButtonTheme(
                                        height: 50.0,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        child: RaisedButton.icon(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(15.0),
                                          ),
                                          elevation: 0.0,
                                          color: primaryColor,
                                          icon: new Text(''),
                                          label: new Text(
                                            'SIGN UP',
                                            style: headingWhite,
                                          ),
                                          onPressed: () async {
//                                                        Navigator.of(context).pushReplacementNamed(AppRoute.introScreen);
                                            if (formKey.currentState
                                                .validate()) {
//                                                        Navigator.of(context).pushReplacement(
//                                                          new MaterialPageRoute(builder: (context) => new HomeScreen()));
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
                                              AuthApiResponse response = await Provider
                                                      .of<
                                                              AuthBloc>(
                                                          context,
                                                          listen: false)
                                                  .signUp(
                                                      firstName:
                                                          firstNameController
                                                              .text
                                                              .trim(),
                                                      lastName:
                                                          lastNameController
                                                              .text
                                                              .trim(),
                                                      phoneNumber: "0" +
                                                          "${phoneController.text.trim()}",
                                                      email: emailController
                                                          .text
                                                          .trim(),
                                                      password:
                                                          passwordController
                                                              .text);
                                              if (response.success) {
                                                Navigator.pop(
                                                    context); //close current progress-bar dialog
                                                Navigator.of(context).push(
                                                  new MaterialPageRoute(
                                                    builder: (context) =>
                                                        PhoneVerification(),
                                                    settings: RouteSettings(
                                                        arguments: {
                                                          "phoneNumber":
                                                              phoneController
                                                                  .text
                                                                  .trim(),
                                                          "verificationType":
                                                              "registration"
                                                        }),
                                                  ),
                                                );
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
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Already have an account? ",
                              style: textGrey,
                            ),
                            new InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(AppRoute.loginScreen),
                              child: new Text(
                                "Sign In",
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
            ]),
          ]),
        ),
      ),
    );
  }
}
