import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../provider/theme_provider/theme_provider.dart';
import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/gradient_background.dart';
import 'package:back_to_firebase/custom_widgets/loader.dart';
import 'package:back_to_firebase/custom_widgets/toast_message.dart';
import 'package:back_to_firebase/provider/auth_provider/auth_provider.dart';
import 'package:back_to_firebase/screens/auth_screens/password_reset/password_reset_screen.dart';
import 'package:back_to_firebase/screens/auth_screens/sign_up/sign_up_page.dart';
import 'package:back_to_firebase/screens/note_screens/all_notes/home.dart';
import 'package:back_to_firebase/secure_storage/secure_storage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPressed = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    loadCredentials();
  }

  Future<void> loadCredentials() async {
    rememberMe = await SecureStorage.getRememberMe();
    if (rememberMe) {
      final email = await SecureStorage.getEmail();
      final password = await SecureStorage.getPassword();
      setState(() {
        _emailController.text = email ?? '';
        _passController.text = password ?? '';
      });
    }
  }

  void toggleEyeButton() {
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
    final local = AppLocalizations.of(context)!;
    bool isDark = Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.dark;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: _buildBody(theme, provider, context, isDark, local),
      ),
    );
  }

  Form _buildBody(ThemeData theme, AuthProvider provider, BuildContext context, bool isDark, AppLocalizations local) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 90.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(local.welcomeBack, style: theme.textTheme.displaySmall?.copyWith(color: Colors.white)),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(local.enterDetails, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
          ),
          SizedBox(height: 50.h),
          Expanded(child: _buildContainer(theme, provider, context, isDark, local)),
        ],
      ),
    );
  }

  Container _buildContainer(ThemeData theme, AuthProvider provider, BuildContext context, bool isDark, AppLocalizations local) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111524) : const Color(0xFFFCF3EC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Text(local.signInTitle, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 30.h),
            _buildEmailField(theme, local),
            SizedBox(height: 20.h),
            _buildPassField(theme, local),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFFe68f50),
                      checkColor: Colors.white,
                      side: theme.checkboxTheme.side,
                    ),
                    Text(local.rememberMe, style: theme.textTheme.titleMedium),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PasswordResetScreen()));
                  },
                  child: Text(
                    local.forgotPassword,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFe68f50)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            CustomButton(
              width: double.infinity,
              height: 50.h,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool success = await provider.signIn(_emailController.text.trim(), _passController.text);
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
                      MaterialPageRoute(
                        builder: (_) => Home(onToggle: Provider.of<ThemeProvider>(context, listen: false).toggleTheme),
                      ),
                    );
                    ToastMsg.successToast(local.signInSuccess);
                  } else {
                    ToastMsg.errorToast(provider.errorMsg!);
                  }
                }
              },
              child: provider.isLoading
                  ? Center(child: Loader.loaderWhite())
                  : Text(
                local.signInButton,
                style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 25.h),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey,thickness: 0.5,),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(local.orSignInWith, style: theme.textTheme.titleMedium),
                ),
                Expanded(child: Divider(color: Colors.grey,thickness: 0.5,)),
              ],
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () async {
                final userCredential = await provider.signInWithGoogle();
                if (userCredential != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Home(
                        onToggle: Provider.of<ThemeProvider>(context, listen: false).toggleTheme,
                      ),
                    ),
                  );
                  ToastMsg.successToast(local.googleSignInSuccess);
                } else {
                  ToastMsg.errorToast(provider.errorMsg ?? local.googleSignInFailed);
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: const Color(0xFFfae7d9),
                side: const BorderSide(color: Color(0xFFe68f50)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  provider.isLoading
                      ? Loader.loaderPurple()
                      : Image.asset('assets/google.png', width: 25.w, height: 25.h),
                  SizedBox(width: 10.w),
                  Text(local.signInWithGoogle, style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(local.dontHaveAccount, style: theme.textTheme.titleMedium),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage()));
                  },
                  child: Text(
                    local.signUpButton,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFe68f50)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildPassField(ThemeData theme, AppLocalizations local) {
    return TextFormField(
      controller: _passController,
      obscureText: !isPressed,
      validator: (value) {
        if (value!.isEmpty) {
          return local.passwordEmptyError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: local.passwordLabel,
        labelStyle: theme.textTheme.titleMedium,
        hintText: local.passwordHint,
        hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
        prefixIcon: Icon(Icons.lock_outline, color: theme.iconTheme.color),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: IconButton(
            onPressed: toggleEyeButton,
            icon: isPressed
                ? Icon(Icons.visibility_outlined, color: theme.iconTheme.color)
                : Icon(Icons.visibility_off_outlined, color: theme.iconTheme.color),
          ),
        ),
      ),
    );
  }

  TextFormField _buildEmailField(ThemeData theme, AppLocalizations local) {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return local.emailEmptyError;
        }
        if (!value.contains('@') || !value.contains('.com')) {
          return local.emailInvalidError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: local.emailLabel,
        labelStyle: theme.textTheme.titleMedium,
        hintText: local.emailHint,
        hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
        prefixIcon: Icon(Icons.email_outlined, color: theme.iconTheme.color),
      ),
    );
  }
}