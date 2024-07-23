import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shop_wise/common/styles/spacing_styles.dart';
import 'package:shop_wise/utils/constants/image_strings.dart';
import 'package:shop_wise/utils/constants/sizes.dart';
import 'package:shop_wise/utils/constants/text_strings.dart';
import 'package:shop_wise/utils/helpers/helper_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
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
                      style: inputTextStyle,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: STexts.email,
                        labelStyle: labelTextStyle, // Set label color
                        floatingLabelStyle: TextStyle(
                            color:
                                floatingLabelColor), // Set floating label color
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: SSizes.spaceBtwInputFields),

                    // Password
                    TextFormField(
                      style: inputTextStyle,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.password_check),
                        labelText: STexts.password,
                        labelStyle: labelTextStyle, // Set label color
                        floatingLabelStyle: TextStyle(
                            color:
                                floatingLabelColor), // Set floating label color
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
                            onPressed: () {},
                            child: const Text(STexts.forgotPassword)),
                      ],
                    ),
                    const SizedBox(height: SSizes.spaceBtwSections),

                    //Sign In Button
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {}, child: Text(STexts.signIn))),
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
                    onPressed: () {},
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
                      onPressed: () {},
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
