import 'package:flutter/material.dart';
import 'package:projeto_controle_financeiro/core/auth/services/auth_service.dart';
import 'package:projeto_controle_financeiro/utils/theme.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController confirmarSenha = TextEditingController();
  TextEditingController nome = TextEditingController();
  TextEditingController foto = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String acessarButton;
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  void setFormAction(bool evento) {
    setState(() {
      isLogin = evento;
      if (isLogin) {
        titulo = 'Controle Financeiro';
        acessarButton = 'Acessar';
        toggleButton = 'Cadastrar';
      } else {
        titulo = 'Crie sua conta';
        acessarButton = 'Cadastrar';
        toggleButton = 'Voltar ao login';
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  registrar() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().registrar(
            email.text,
            senha.text,
            nome.text,
            foto.text,
          );
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 320,
              height: 610,
              child: Card(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 26),
                          child: Text(
                            titulo,
                            style: TextStyle(
                                color: projectTheme.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        !isLogin
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: nome,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nome de usuário',
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Informe o seu nome.';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: email,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o seu email corretamente.';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: senha,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Senha',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe a sua senha.';
                              } else if (value.length < 6) {
                                return 'Senha inválida.';
                              }
                              return null;
                            },
                          ),
                        ),
                        !isLogin
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: confirmarSenha,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Repita sua senha',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Repita a sua senha.';
                                    } else if (value != senha.text) {
                                      return 'A senha não é a mesma.';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            : Container(),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (isLogin) {
                                login();
                              } else {
                                registrar();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: projectTheme.primaryColor,
                            fixedSize: const Size(130, 10),
                          ),
                          child: loading
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 30,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Text(acessarButton),
                        ),
                        ElevatedButton(
                          onPressed: () => setFormAction(!isLogin),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            fixedSize: const Size(130, 10),
                          ),
                          child: Text(toggleButton),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
