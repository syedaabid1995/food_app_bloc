
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/UI/home/bottom_navigation.dart';
import 'package:food_app/bloc/login/login_event.dart';
import 'package:food_app/model/login/login_model.dart';
import 'package:food_app/utils/asset_files.dart';
import 'package:food_app/utils/snackbar.dart';
import 'package:hive/hive.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_state.dart';
import '../../constants/colors.dart';
import '../../utils/navigation.dart';
import '../../utils/save_to_hive.dart';



class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final loginBloc;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  var emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  var passwordRegex = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$");
  Box? _userBox;

  @override
  void initState() {
    super.initState();
    /// To Hide keyboard on init
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    loginBloc = BlocProvider.of<LoginBloc>(context);
    loginBloc.add(ProcessInitial());
    initBox();

  }

  @override
  void dispose() {
    super.dispose();
  }

  void initBox() async {
    _userBox = await Hive.openBox(HiveKeys.userBox);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if(state is LoginError){
          snackBar(context, state.error, isSuccess: false);
        }
        if(state is LoginLoaded){

          snackBar(context, state.response!.message!, isSuccess: true);
          Navigate().navigateAndReplace(
              context,
              HomeScreen());
        }
      },
      child: loginScreenUI(),
    );
  }

  Widget loginScreenUI() {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: body(),
          )
        ],
      ),
    );
  }
  Widget sizedBox({double height = 0.0,double width= 0.0}){
    return  SizedBox(
      height: height,
      width: width,
    );
  }

  Widget body() {
    return Container(
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          sizedBox(
            height: 40,
          ),
          imageLogo(AssetFiles.appIcon),
          // Spacer(),
          centerSection(),
          sizedBox(
            height: 40,
          ),

        ],
      ),
    );
  }


  void submit() async {
    LoginModel loginModel = LoginModel(_emailController.text, _passwordController.text);
    loginBloc.add(ProcessLogin(loginModel, _userBox!));
  }

  Widget centerSection() {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 26, color: Colors.black),
                ),

                SizedBox(
                  height: 20,
                ),

                TextFormField(
                  validator: (email) {
                    if (email!.isEmpty) {
                      return 'Email field cannot be Empty';
                    } else if (!emailRegex.hasMatch(email)) {
                      return 'Please enter a valid email id';
                    } else {
                      return null;
                    }
                  },
                  toolbarOptions: ToolbarOptions(
                      copy: true, paste: true, cut: true, selectAll: true),

                  textInputAction: TextInputAction.next,
                  autocorrect: true,
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  key: Key("email"),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: appPrimaryColor,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: appPrimaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xffE5E5E5),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.red,
                        )),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (password) {
                    if (password!.isEmpty) {
                      return 'Password field cannot be Empty';
                    } else if (!passwordRegex.hasMatch(password)) {
                      return 'Please enter a valid password';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  toolbarOptions: ToolbarOptions(
                      copy: true, paste: true, cut: true, selectAll: true),
                  textInputAction: TextInputAction.done,
                  autocorrect: true,
                  controller: _passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  key: Key("password"),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: appPrimaryColor,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: appPrimaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xffE5E5E5),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.red,
                        )),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: submit,
              child: Text(
                "Sign In",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),)
          ],
        ));
  }








}