import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/gradient_background.dart';
import 'package:back_to_firebase/custom_widgets/loader.dart';
import 'package:back_to_firebase/custom_widgets/toast_message.dart';
import 'package:back_to_firebase/provider/auth_provider/auth_provider.dart';
import 'package:back_to_firebase/screens/auth_screens/password_reset/password_reset_screen.dart';
import 'package:back_to_firebase/screens/auth_screens/sign_up/sign_up_page.dart';
import 'package:back_to_firebase/screens/note_screens/all_notes/home.dart';
import 'package:back_to_firebase/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/theme_provider/theme_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  @override
  void initState() {
    loadCredentials();
    super.initState();
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPressed = false;

  bool rememberMe = false;

  Future<void> loadCredentials()async{
    rememberMe = await SecureStorage.getRememberMe();
    if(rememberMe){
      final email = await SecureStorage.getEmail();
      final password = await SecureStorage.getPassword();
      setState(() {
        _emailController.text = email ?? '';
        _passController.text = password ?? '';
      });
    }
  }

  void toggleEyeButton(){
    setState(() {
      isPressed = !isPressed;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final provider = Provider.of<AuthProvider>(context);
    bool isDark = Provider.of<ThemeProvider>(context,listen: false).themeMode==ThemeMode.dark;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: buildBody(theme, provider, context, isDark),
      ),
    );
  }

  Form buildBody(ThemeData theme, AuthProvider provider, BuildContext context, bool isDark) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 90,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text("Welcome back",style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text("Enter your details below and get started",style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),),
            ),
            const SizedBox(height: 50,),
            Expanded(
                child: _buildContainer(theme, provider, context, isDark )
            ),
          ],
        )
    );
  }

  Container _buildContainer(ThemeData theme, AuthProvider provider, BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
          color: isDark? Color(0xFF111524):Color(0xFFFCF3EC),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            Text("Sign In",style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,),),
            const SizedBox(height: 30,),
            _buildEmailField(theme),
            const SizedBox(height: 20,),
            _buildPassField(theme),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value){
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                      activeColor: Color(0xFFe68f50),
                      checkColor: Colors.white,
                      side: theme.checkboxTheme.side,

                    ),
                    Text("Remember me",style: theme.textTheme.titleMedium,)
                  ],
                ),
                Row(
                  children: [

                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PasswordResetScreen()));
                        },
                        child: Text('Forgot Password?',style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,color: Color(0xFFe68f50)),)
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10,),
            CustomButton(
              width: double.infinity,
              height: 55,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool success = await provider.signIn(
                    _emailController.text.trim(),
                    _passController.text,
                  );

                  if (success) {
                    if (rememberMe) {
                      await SecureStorage.saveEmail(_emailController.text.trim());
                      await SecureStorage.savePassword(_passController.text);
                      await SecureStorage.saveRememberMe(true);
                    } else {
                      await SecureStorage.clearAll();
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home(
                        onToggle: Provider.of<ThemeProvider>(context, listen: false).toggleTheme,
                      )),
                    );
                    ToastMsg.successToast('Successfully signed in');
                  } else {
                    ToastMsg.errorToast(provider.errorMsg!);
                  }
                }
              },

              child: provider.isLoading? Center(child: Loader.loaderWhite(),)
                  :Text("Sign In",style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 25,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    height: 1,
                    color: isDark? Colors.white :Colors.black,
                  ),
                ),
                Text(
                  "Or, sign in with",
                  style: theme.textTheme.titleMedium,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: 1,
                    color: isDark? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                final userCredential = await provider.signInWithGoogle();

                if (userCredential != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        onToggle: Provider.of<ThemeProvider>(context, listen: false).toggleTheme,
                      ),
                    ),
                  );
                  ToastMsg.successToast('Signed in with Google');
                } else {
                  ToastMsg.errorToast(provider.errorMsg ?? "Google sign-in failed");
                }
              },

              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: Size(double.infinity, 55),
                  backgroundColor: Color(0xFFfae7d9),
                  side: BorderSide(
                      color: Color(0xFFe68f50)
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  provider.isLoading? Center(child: Loader.loaderPurple(),)
                      :Image.asset(
                    'assets/google.png',
                    fit: BoxFit.cover,
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(width: 10,),
                  Text("Continue with Google",style: TextStyle(color: Colors.black),)
                ],
              ),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",style: theme.textTheme.titleMedium,),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                  },
                  child: Text("Sign Up",style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,color: Color(0xFFe68f50)),),

                )
              ],
            ),



          ],
        ),
      ),
    );
  }

  TextFormField _buildPassField(ThemeData theme) {
    return TextFormField(
      controller: _passController,
      obscureText: isPressed? false : true,
      validator: (String? value){
        if(value!.isEmpty){
          return "Please enter your password";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: theme.textTheme.titleMedium,
          hintText: 'Enter your password',
          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
          prefixIcon: Icon(Icons.lock_outline,color: theme.iconTheme.color,),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: toggleEyeButton,
                icon: isPressed? Icon(Icons.visibility_outlined,color: theme.iconTheme.color,) : Icon(Icons.visibility_off_outlined,color: theme.iconTheme.color,)
            ),
          )
      ),
    );
  }

  TextFormField _buildEmailField(ThemeData theme) {
    return TextFormField(
      controller: _emailController,
      validator: (String? value){
        if(value!.isEmpty){
          return "Please enter an email address";
        }
        if(!_emailController.text.contains('@') || !_emailController.text.contains('.com')){
          return "Please enter a valid email address";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: theme.textTheme.titleMedium,
          hintText: 'Enter your email address',
          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
          prefixIcon: Icon(Icons.email_outlined,color: theme.iconTheme.color,)
      ),
    );
  }
}