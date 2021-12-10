import 'package:flutter/material.dart';

import 'package:app_for_dev/ui/pages/pages.dart';

import 'package:app_for_dev/ui/components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  LoginPage(this.presenter);

  void _onCreateAccount() {

  }

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
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-Mail',
                          icon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColorLight),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: presenter?.validateEmail,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 32),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            icon: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          obscureText: true,
                          onChanged: presenter?.validatePassword,
                        ),
                      ),
                      const ElevatedButton(
                        child: Text('Entrar'),
                        onPressed: null,
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


