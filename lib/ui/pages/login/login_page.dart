import 'package:flutter/material.dart';

import 'package:app_for_dev/ui/components/components.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({Key? key}) : super(key: key);

  void _onCriarConta() {

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
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Entrar'),
                        onPressed: _onCriarConta,
                      ),
                      TextButton.icon(
                        label: const Text('Criar conta'),
                        icon: const Icon(Icons.person),
                        onPressed: _onCriarConta,
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


