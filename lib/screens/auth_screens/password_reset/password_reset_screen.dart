import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/gradient_background.dart';
import 'package:back_to_firebase/custom_widgets/loader.dart';
import 'package:back_to_firebase/custom_widgets/toast_message.dart';
import 'package:back_to_firebase/provider/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../provider/theme_provider/theme_provider.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(local.resetPasswordTitle, style: theme.textTheme.displaySmall?.copyWith(color: Colors.white)),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(local.resetPasswordInstruction, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18.r), topRight: Radius.circular(20.r)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Text(local.enterYourEmail, style: theme.textTheme.titleLarge?.copyWith(color: const Color(0xFFe68f50), fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),
            _buildEmailField(theme, local),
            SizedBox(height: 20.h),
            CustomButton(
              width: double.infinity.w,
              height: 55.h,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool success = await provider.resetPassword(_emailController.text.trim());
                  if (success) {
                    Navigator.pop(context);
                    ToastMsg.successToast(local.resetSuccess);
                  } else {
                    ToastMsg.errorToast(provider.errorMsg!);
                  }
                }
              },
              child: provider.isLoading
                  ? Center(child: Loader.loaderWhite())
                  : Text(local.sendLinkButton,
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
             SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(local.rememberPassword, style: theme.textTheme.titleMedium),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(local.signInButton,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFe68f50))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildEmailField(ThemeData theme, AppLocalizations local) {
    return TextFormField(
      controller: _emailController,
      validator: (String? value) {
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
}
