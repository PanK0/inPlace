import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inplace/pages/homePage.dart';
import 'package:provider/provider.dart';

import 'utils/applicationState.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/home',
        routes: {
          // Home Page class, pages/homePage.dart
          '/home': (context) {
            return const HomePage();
          },
          // sign-in screen, package:firebase_ui_auth/src/screens/sign_in_screen.dart
          '/sign-in': ((context) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  Navigator.of(context).pushNamed('/forgot-password',
                      arguments: {'email': email});
                })),
                AuthStateChangeAction(((context, state) {
                  if (state is SignedIn || state is UserCreated) {
                    var user = (state is SignedIn)
                        ? state.user
                        : (state as UserCreated).credential.user;
                    if (user == null) {
                      return;
                    }
                    if (state is UserCreated) {
                      user.updateDisplayName(user.email!.split('@')[0]);
                    }
                    if (!user.emailVerified) {
                      user.sendEmailVerification();
                      const snackBar = SnackBar(
                          content: Text(
                              'Please check your email to verify your email address'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                })),
              ],
            );
          }),
          // forgot-password screen, package:firebase_ui_auth/src/screens/forgot_password_screen.dart
          '/forgot-password': ((context) {
            final arguments = ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>?;

            return ForgotPasswordScreen(
              email: arguments?['email'] as String,
              headerMaxExtent: 200,
            );
          }),
          // profile screen, package:firebase_ui_auth/src/screens/profile_screen.dart
          '/profile': ((context) {
            return ProfileScreen(
              providers: [],
              actions: [
                SignedOutAction(
                  ((context) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  }),
                ),
              ],
            );
          })
        },
        title: 'inPlace',
        theme: ThemeData(
          /*
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.deepPurple,
            ),
        */
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        )
        // Home Page
        //home: const HomePage(),
        );
  }
}
