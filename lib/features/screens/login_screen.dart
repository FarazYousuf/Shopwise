import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shop_wise/common/styles/spacing_styles.dart';
import 'package:shop_wise/utils/constants/image_strings.dart';
import 'package:shop_wise/utils/constants/sizes.dart';
import 'package:shop_wise/utils/constants/text_strings.dart';
import 'package:shop_wise/utils/helpers/helper_functions.dart';
import 'package:shop_wise/features/screens/main_screen.dart';
import 'package:shop_wise/features/screens/signup_screen.dart';
import 'package:shop_wise/features/authentication/providers/auth_providers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

// Sign in with Email and Password

  Future<void> _signInWithEmail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      await authProvider.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    } catch (e) {
      print('Error signing in with email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with email. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Sign in with Google

  // Future<void> _signInWithGoogle() async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   try {
  //     await authProvider.signInWithGoogle();
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
  //   } catch (e) {
  //     print('Error signing in with Google: $e');
  //   }
  // }

// Recent method (Testing)
  Future<void> _signInWithGoogle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      await authProvider.signInWithGoogle();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    } catch (e) {
      print('Error signing in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with Google. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Sign in with Apple

  // Future<void> _signInWithApple() async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   try {
  //     await authProvider.signInWithApple();
  //     Navigator.of(context)
  //         .pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
  //   } catch (e) {
  //     print('Error signing in with Apple: $e');
  //   }
  // }

  Future<void> _signInWithApple() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      await authProvider.signInWithApple();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => MainScreen()));
    } catch (e) {
      print('Error signing in with Apple: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with Apple. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Pasword Reset Email

  // Send Password Reset Email
  Future<void> _sendPasswordResetEmail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.sendPasswordResetEmail(_emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Reset email sent.'),
        ),
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error sending password eset email. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    // final dark = SHelperFunctions.isDarkMode(context);
    final bool isDarkMode = SHelperFunctions.isDarkMode(context);

    final Color labelColor = isDarkMode ? Colors.white : Colors.black;
    final Color floatingLabelColor = labelColor;
    final Color dividerColor = isDarkMode ? Colors.grey[800]! : Colors.grey;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final TextStyle inputTextStyle = TextStyle(color: textColor);

    // Get the headline style and provide a default if it's null
    final TextStyle headlineStyle =
        Theme.of(context).textTheme.headlineMedium ?? TextStyle();
    final TextStyle labelTextStyle = TextStyle(color: labelColor);
    final TextStyle textTextStyle = TextStyle(color: textColor);

    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: SspacingStyle.paddingWithAppBarHeight,
        child: Column(
          children: [
            // Logo & Title
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Logo
                  // Image(height: 150, image: AssetImage('')),
                  const SizedBox(height: SSizes.md),
                  Text(
                    STexts.loginTitle,
                    style: headlineStyle.copyWith(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SSizes.xl),
                  // Text(STexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            ),

            // Text Input Form
            Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: SSizes.spaceBtwSections),
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      controller: _emailController,
                      style: inputTextStyle,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: STexts.email,
                        labelStyle: labelTextStyle,
                        floatingLabelStyle:
                            TextStyle(color: floatingLabelColor),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: SSizes.spaceBtwInputFields),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      style: inputTextStyle,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.password_check),
                        labelText: STexts.password,
                        labelStyle: labelTextStyle,
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
                    const SizedBox(height: SSizes.spaceBtwInputFields / 2),

                    //Remember Me & Forget Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Remember Me
                        Row(
                          children: [
                            Checkbox(value: true, onChanged: (value) {}),
                            Text(
                              STexts.rememberMe,
                              style: textTextStyle,
                            )
                          ],
                        ),
                        //Forget Password
                        TextButton(
                            onPressed: _sendPasswordResetEmail,
                            // onPressed: () {},
                            child: const Text(STexts.forgotPassword)),
                      ],
                    ),
                    const SizedBox(height: SSizes.spaceBtwSections),

                    //Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signInWithEmail,
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text(STexts.signIn),
                      ),
                    ),
                    const SizedBox(
                      height: SSizes.spaceBtwItems,
                    ),

                    //Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor:
                              isDarkMode ? Colors.white : Colors.black,
                          side: BorderSide(
                              color: isDarkMode ? Colors.grey : Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SignUpScreen()));
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text(STexts.createAccount),
                      ),
                    ),
                    const SizedBox(
                      height: SSizes.spaceBtwSections,
                    )
                  ],
                ),
              ),
            ),

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
                    // onPressed: authProvider.signInWithGoogle,
                     onPressed: _isLoading ? null : _signInWithGoogle,
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
                      // onPressed: authProvider.signInWithApple,
                       onPressed: _isLoading ? null : _signInWithApple,
                      icon: Image(
                        width: SSizes.iconMd,
                        height: SSizes.iconMd,
                        image: AssetImage(
                          isDarkMode ? SImages.appleWhite : SImages.appleBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
