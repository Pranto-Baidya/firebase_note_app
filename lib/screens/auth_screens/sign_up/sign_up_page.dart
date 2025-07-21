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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPressed = false;
  bool isPressedNew = false;

  void toggleEyeButton() => setState(() => isPressed = !isPressed);
  void toggleEyeButtonNew() => setState(() => isPressedNew = !isPressedNew);

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
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
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Text(local.createAccount, style: theme.textTheme.displaySmall?.copyWith(color: Colors.white)),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Text(local.enterDetailsSignup, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
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
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Text(
                local.signUpTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFe68f50),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              _buildNameField(theme, local),
              SizedBox(height: 20.h),
              _buildEmailField(theme, local),
              SizedBox(height: 20.h),
              _buildPassField(theme, local),
              SizedBox(height: 20.h),
              _buildConfirmPassField(theme, local),
              SizedBox(height: 20.h),
              CustomButton(
                width: double.infinity,
                height: 55.h,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool success = await provider.signUp(
                      _nameController.text,
                      _emailController.text.trim(),
                      _passController.text,
                    );
                    if (success) {
                      Navigator.pop(context);
                      ToastMsg.successToast(local.signUpSuccess);
                    } else {
                      ToastMsg.errorToast(provider.errorMsg!);
                    }
                  }
                },
                child: provider.isLoading
                    ? Center(child: Loader.loaderWhite())
                    : Text(
                  local.signUpButton,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(local.alreadyHaveAccount, style: theme.textTheme.titleMedium),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      local.signInButton,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFe68f50),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildNameField(ThemeData theme, AppLocalizations local) {
    return TextFormField(
      controller: _nameController,
      validator: (value) => value!.isEmpty ? local.nameEmptyError : null,
      decoration: InputDecoration(
        labelText: local.nameLabel,
        labelStyle: theme.textTheme.titleMedium,
        hintText: local.nameHint,
        hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
        prefixIcon: Icon(Icons.person_outline, color: theme.iconTheme.color),
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
        if (!_emailController.text.contains('@') || !_emailController.text.contains('.com')) {
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

  TextFormField _buildPassField(ThemeData theme, AppLocalizations local) {
    return TextFormField(
      controller: _passController,
      obscureText: !isPressed,
      validator: (value) {
        if (_passController.text.length < 6) {
          return local.passwordTooShortError;
        }
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

  TextFormField _buildConfirmPassField(ThemeData theme, AppLocalizations local) {
    return TextFormField(
      controller: _confirmPassController,
      obscureText: !isPressedNew,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value != _passController.text) {
          return local.passwordsDoNotMatchError;
        }
        if (value!.isEmpty) {
          return local.confirmPasswordEmptyError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: local.confirmPasswordLabel,
        labelStyle: theme.textTheme.titleMedium,
        hintText: local.confirmPasswordHint,
        hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
        prefixIcon: Icon(Icons.password, color: theme.iconTheme.color),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: IconButton(
            onPressed: toggleEyeButtonNew,
            icon: isPressedNew
                ? Icon(Icons.visibility_outlined, color: theme.iconTheme.color)
                : Icon(Icons.visibility_off_outlined, color: theme.iconTheme.color),
          ),
        ),
      ),
    );
  }
}
