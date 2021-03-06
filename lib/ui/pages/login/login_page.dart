import 'package:flutter/material.dart';

import 'package:app_for_dev/ui/pages/pages.dart';

import 'package:app_for_dev/ui/components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  LoginPage(this.presenter);

  void _onCreateAccount() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const HeadLine1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    StreamBuilder<String>(
                      stream: presenter?.emailErrorController,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            icon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            errorText: snapshot.data?.isEmpty == true
                                ? null
                                : snapshot.data,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: presenter?.validateEmail,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      child: StreamBuilder<String>(
                        stream: presenter?.passwordErrorController,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              icon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data,
                            ),
                            obscureText: true,
                            onChanged: presenter?.validatePassword,
                          );
                        },
                      ),
                    ),
                    StreamBuilder<bool>(
                      stream: presenter?.formValidController,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                          child: const Text('Entrar'),
                          onPressed: snapshot.data == true
                                ? _onCreateAccount
                                : null,
                        );
                      },
                    ),
                    TextButton.icon(
                      label: const Text('Criar conta'),
                      icon: const Icon(Icons.person),
                      onPressed: _onCreateAccount,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
