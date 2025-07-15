
import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/gradient_background.dart';
import 'package:back_to_firebase/custom_widgets/loader.dart';
import 'package:back_to_firebase/custom_widgets/toast_message.dart';
import 'package:back_to_firebase/provider/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    bool isDark = Provider.of<ThemeProvider>(context,listen: false).themeMode==ThemeMode.dark;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: _buildBody(theme, provider, context,isDark),
      ),
    );
  }


  Form _buildBody(ThemeData theme, AuthProvider provider, BuildContext context, isDark) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 90,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text("Reset password",style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text("Don't worry! Please enter the email address linked with your account",style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),),
            ),
            const SizedBox(height: 50,),
            Expanded(
                child: _buildContainer(theme, provider, context,isDark)
            ),
          ],
        )
    );
  }

  Container _buildContainer(ThemeData theme, AuthProvider provider, BuildContext context,bool isDark) {
    return Container(
      decoration: BoxDecoration(
          color: isDark? Color(0xFF111524):Color(0xFFFCF3EC),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(20))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            Text("Enter your email",style: theme.textTheme.titleLarge?.copyWith(color: Color(0xFFe68f50),fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            _buildEmailField(theme),
            const SizedBox(height: 20,),
            CustomButton(
              width: double.infinity,
              height: 55,
              onPressed: ()async{
                if(_formKey.currentState!.validate()){
                  bool success = await provider.resetPassword(
                      _emailController.text.trim()
                  );
                  if(success){
                    Navigator.pop(context);
                    ToastMsg.successToast('Successfully sent a password reset link to your email');
                  }
                  else{
                    ToastMsg.errorToast(provider.errorMsg!);
                  }
                }
              },
              child: provider.isLoading?Center(child: Loader.loaderWhite(),)
              :Text("Send link",style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 300,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Remember password?",style: theme.textTheme.titleMedium,),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Sign In",style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,color: Color(0xFFe68f50)),),

                )
              ],
            ),
          ],
        ),
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

