
import 'package:back_to_firebase/custom_widgets/custom_button.dart';
import 'package:back_to_firebase/custom_widgets/gradient_background.dart';
import 'package:back_to_firebase/custom_widgets/loader.dart';
import 'package:back_to_firebase/custom_widgets/toast_message.dart';
import 'package:back_to_firebase/provider/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/theme_provider/theme_provider.dart';

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

  void toggleEyeButton(){
    setState(() {
      isPressed = !isPressed;
    });
  }

  bool isPressedNew = false;

  void toggleEyeButtonNew(){
    setState(() {
      isPressedNew = !isPressedNew;
    });
  }

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
    bool isDark = Provider.of<ThemeProvider>(context,listen: false).themeMode==ThemeMode.dark;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: _buildBody(theme, provider, context, isDark ),
      ),
    );
  }


  Form _buildBody(ThemeData theme, AuthProvider provider, BuildContext context,bool isDark) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 90,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text("Create account",style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text("Enter your details below and join with us today",style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),),
            ),
            const SizedBox(height: 50,),
            Expanded(
                child: _buildContainer(theme, provider, context, isDark)
            ),
          ],
        )
    );
  }

  Container _buildContainer(ThemeData theme, AuthProvider provider, BuildContext context,bool isDark) {
    return Container(
      decoration: BoxDecoration(
          color: isDark? Color(0xFF111524):Color(0xFFFCF3EC),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              Text("Sign Up",style: theme.textTheme.titleLarge?.copyWith(color: Color(0xFFe68f50),fontWeight: FontWeight.bold),),
              const SizedBox(height: 30,),
              _buildNameField(theme),
              const SizedBox(height: 20,),
              _buildEmailField(theme),
              const SizedBox(height: 20,),
              _buildPassField(theme),
              const SizedBox(height: 20,),
              _buildConfirmPassField(theme),
              const SizedBox(height: 20,),
          
              CustomButton(
                width: double.infinity,
                height: 55,
                onPressed: ()async{
                  if(_formKey.currentState!.validate()){
                    bool success = await provider.signUp(
                        _emailController.text.trim(),
                        _passController.text
                    );
                    if(success){
                      Navigator.pop(context);
                      ToastMsg.successToast('Successfully signed up, You can login now');
                    }
                    else{
                      ToastMsg.errorToast(provider.errorMsg!);
                    }
                  }
                },
                child: provider.isLoading?Center(child: Loader.loaderWhite(),)
                    :Text("Sign Up",style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",style: theme.textTheme.titleMedium,),
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
      ),
    );
  }

  TextFormField _buildPassField(ThemeData theme) {
    return TextFormField(
      controller: _passController,
      obscureText: isPressed? false : true,
      validator: (String? value){
        if(_passController.text.length<6){
          return "Password should be a minimum of 6 characters ";
        }
        if(value!.isEmpty){
          return "Password cannot be empty";
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

  TextFormField _buildNameField(ThemeData theme) {
    return TextFormField(
      controller: _nameController,
      validator: (String? value){
        if(value!.isEmpty){
          return "Please enter your name";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Name',
          labelStyle: theme.textTheme.titleMedium,
          hintText: 'Enter your full name',
          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
          prefixIcon: Icon(Icons.person_outline,color: theme.iconTheme.color,)
      ),
    );
  }

  TextFormField _buildConfirmPassField(ThemeData theme) {
    return TextFormField(
      controller: _confirmPassController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isPressedNew ? false : true,
      validator: (String? value){
        if(value!=_passController.text){
          return "Passwords don't match ";
        }
        if(value!.isEmpty){
          return "Please confirm your password";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Confirm password',
          labelStyle: theme.textTheme.titleMedium,
          hintText: 'Enter the correct password',
          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
          prefixIcon: Icon(Icons.password,color: theme.iconTheme.color,),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: toggleEyeButtonNew,
                icon: isPressedNew? Icon(Icons.visibility_outlined,color: theme.iconTheme.color,) : Icon(Icons.visibility_off_outlined,color: theme.iconTheme.color,)
            ),
          )
      ),
    );
  }
}

