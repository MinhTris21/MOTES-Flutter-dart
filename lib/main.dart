library dart.developer;

import 'package:basic_flutter/constant/routes.dart';
import 'package:basic_flutter/helpers/loading/loading_screen.dart';
import 'package:basic_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:basic_flutter/services/auth/bloc/auth_event.dart';
import 'package:basic_flutter/services/auth/bloc/auth_state.dart';
import 'package:basic_flutter/services/auth/firebase_auth_provider.dart';
import 'package:basic_flutter/views/forgot_password_view.dart';
import 'package:basic_flutter/views/login_view.dart';
import 'package:basic_flutter/views/notes/create_update_note_view.dart';
import 'package:basic_flutter/views/notes/notes_view.dart';
import 'package:basic_flutter/views/register_view.dart';
import 'package:basic_flutter/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Basic project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else {
          return const Scaffold(body: CircularProgressIndicator());
        }
      },
    );
  }
}
