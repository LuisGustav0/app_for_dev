import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({Key? key}) : super(key: key);

  void _onCriarConta() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Image(image: AssetImage('lib/ui/assets/logo.png')),
            Text('Login'.toUpperCase()),
            Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'E-Mail',
                        icon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    TextButton.icon(
                      label: const Text('Criar conta'),
                      icon: const Icon(Icons.person),
                      onPressed: _onCriarConta,
                    ),
                  ],
                ),
            )
          ],
        ),
      ),
    );
  }
}
