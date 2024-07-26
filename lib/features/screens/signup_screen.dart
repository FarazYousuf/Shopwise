import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shop_wise/utils/constants/image_strings.dart';
import 'package:shop_wise/features/authentication/providers/auth_providers.dart';
import 'package:shop_wise/features/screens/main_screen.dart';
import 'package:shop_wise/utils/constants/sizes.dart';
import 'package:shop_wise/utils/constants/text_strings.dart';
import 'package:shop_wise/utils/helpers/helper_functions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  // final _usernameController = TextEditingController();
  // final _phoneNumberController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      await authProvider.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
      );
      //  await authProvider.signUpWithEmailAndPassword(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text.trim(),
      //   firstName: _firstNameController.text.trim(),
      //   lastName: _lastNameController.text.trim(),
      //   username: _usernameController.text.trim(),
      //   phoneNumber: _phoneNumberController.text.trim(),
      // );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    } catch (e) {
      print('Error signing up: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


 // Sign Up with Google
  Future<void> _signUpWithGoogle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      await authProvider.signInWithGoogle();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    } catch (e) {
      print('Error signing up with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up with Google. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Sign Up with Apple
  Future<void> _signUpWithApple() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      await authProvider.signInWithApple();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    } catch (e) {
      print('Error signing up with Apple: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up with Apple. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  


  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final bool isDarkMode = SHelperFunctions.isDarkMode(context);

    final Color labelColor = isDarkMode ? Colors.grey : Colors.black;
    final Color floatingLabelColor = labelColor;
    final Color dividerColor = isDarkMode ? Colors.grey[800]! : Colors.grey;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final TextStyle inputTextStyle = TextStyle(color: textColor);

    // Get the headline style and provide a default if it's null
    final TextStyle headlineStyle = Theme.of(context).textTheme.headlineMedium ?? TextStyle();
    final TextStyle labelTextStyle = TextStyle(color: labelColor);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SSizes.defaultSpace),
          child: Column(
            children: [
              // Logo & Title
              Center(
                child: Column(
                  children: [
                    Text(
                      STexts.signupTitle,
                      style: headlineStyle.copyWith(color: textColor),
                    ),
                    const SizedBox(height: SSizes.spaceBtwSections / 2),

                    Form(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  style: inputTextStyle,
                                  expands: false,
                                  decoration: InputDecoration(
                                    labelText: STexts.firstName,
                                    labelStyle: TextStyle(fontSize: 13),
                                    prefixIcon: Icon(Iconsax.user),
                                    floatingLabelStyle:
                                        TextStyle(color: floatingLabelColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: SSizes.spaceBtwInputFields),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  style: inputTextStyle,
                                  expands: false,
                                  decoration: InputDecoration(
                                    labelText: STexts.lastName,
                                    labelStyle: TextStyle(fontSize: 13),
                                    prefixIcon: Icon(Iconsax.user),
                                    floatingLabelStyle:TextStyle(color: floatingLabelColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: SSizes.spaceBtwInputFields),

                          //Username
                          TextFormField(

                            style: inputTextStyle,
                            expands: false,
                            decoration: InputDecoration(
                              labelText: STexts.userName,
                              prefixIcon: Icon(Iconsax.user_edit),
                              labelStyle: TextStyle(fontSize: 13),
                              floatingLabelStyle: TextStyle(color: floatingLabelColor),
                            ),
                          ),
                          const SizedBox(height: SSizes.spaceBtwInputFields),

                          //Email
                          TextFormField(
                            controller: _emailController,
                            style: inputTextStyle,
                            decoration: InputDecoration(
                              labelText: STexts.email,
                              // labelStyle: labelTextStyle,
                              prefixIcon: Icon(Iconsax.direct),
                              labelStyle: TextStyle(fontSize: 13),
                              floatingLabelStyle:
                                  TextStyle(color: floatingLabelColor),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: SSizes.spaceBtwInputFields),

                          //Password
                          TextFormField(
                            controller: _passwordController,
                            style: inputTextStyle,
                            decoration: InputDecoration(
                              labelText: STexts.password,
                              // labelStyle: labelTextStyle,
                              prefixIcon: Icon(Iconsax.password_check),
                              labelStyle: TextStyle(fontSize: 13),
                              floatingLabelStyle:
                                  TextStyle(color: floatingLabelColor),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Iconsax.eye
                                      : Iconsax.eye_slash,
                                  color: labelColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: SSizes.spaceBtwInputFields),

                          //Phone Number
                          TextFormField(
                            style: inputTextStyle,
                            decoration: InputDecoration(
                              labelText: STexts.phoneNo,
                              // labelStyle: labelTextStyle,
                              prefixIcon: Icon(Iconsax.call),
                              labelStyle: TextStyle(fontSize: 13),
                              floatingLabelStyle:
                                  TextStyle(color: floatingLabelColor),
                              border: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: SSizes.spaceBtwSections),

                          // Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signUp,
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : Text(STexts.createAccount),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox( height: SSizes.spaceBtwSections),

                    //Divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Divider(
                            color: dividerColor,
                            thickness: 0.5,
                            indent: 60,
                            endIndent: 5,
                          ),
                        ),
                        Text(
                          STexts.orSignInWith.toUpperCase(),
                          style: labelTextStyle,
                        ),
                        Flexible(
                          child: Divider(
                            color: dividerColor,
                            thickness: 0.5,
                            indent: 5,
                            endIndent: 60,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: SSizes.spaceBtwSections,
                    ),

                    //Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: dividerColor),
                              borderRadius: BorderRadius.circular(100)),
                          child: IconButton(
                            onPressed: _isLoading ? null : _signUpWithGoogle,
                            icon: const Image(
                              width: SSizes.iconMd,
                              height: SSizes.iconMd,
                              image: AssetImage(SImages.google),
                            ),
                          ),
                        ),
                        const SizedBox(width: SSizes.spaceBtwItems),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: dividerColor),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: IconButton(
                              onPressed: _isLoading ? null : _signUpWithApple,
                              icon: Image(
                                width: SSizes.iconMd,
                                height: SSizes.iconMd,
                                image: AssetImage(
                                  isDarkMode
                                      ? SImages.appleWhite
                                      : SImages.appleBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
