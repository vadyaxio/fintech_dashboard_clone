import 'package:flutter/material.dart';
import 'package:maxbonus_index/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _isStartMan = false;
  bool _isStartBackground = false;
  bool _isLoading = false;
  bool _isPasswordVisible = true;
  late AnimationController _controller;
  final String _url = 'https://maxbonus.ru/?utm_source=maxbonus-app';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1600), () {
      setState(() {
        _isStartMan = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isStartBackground = true;
      });
    });

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchURL() async {
    if (!await launch(_url)) throw 'Ошибка открытия $_url';
  }

  void submitForm() async {
    // print(_nameController.text);
    // print(_passwordController.text);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      API()
          .loginApi(User(_nameController.text, _passwordController.text))
          .then((result) => {
                print(result),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result["message"].toString())),
                ),
                setState(() {
                  _isLoading = false;
                }),
                if (!result["hasError"])
                  Future(() {
                    Navigator.of(context).popAndPushNamed('/');
                  })
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Responsive.isMobile(context)
                ? Stack(
                    children: [
                      AnimatedOpacity(
                          opacity: _isStartBackground ? 1.0 : 0.0,
                          duration: const Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                //scale: 0.1,
                                image: AssetImage("assets/auth_background.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )),
                      AnimatedPositioned(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          top: _isStartMan ? 50.0 : 0.0,
                          duration: const Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn,
                          child: Container(
                              margin: const EdgeInsets.fromLTRB(30, 0, 30, 500),
                              child: Image.asset(
                                'assets/charts.png',
                              ))),
                      AnimatedPositioned(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          top: _isStartMan ? 0.0 : 100.0,
                          duration: const Duration(seconds: 2),
                          curve: Curves.fastOutSlowIn,
                          child: Container(
                              margin:
                                  const EdgeInsets.fromLTRB(50, 20, 50, 360),
                              child: Image.asset(
                                'assets/man.png',
                              ))),
                    ],
                  )
                : const SizedBox(
                    height: 50,
                  ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 100),
                child: Image.asset(
                  'assets/logo.png',
                  width: MediaQuery.of(context).size.width,
                )),
            const SizedBox(
              height: 8,
            ),
            _isLoading
                ? Column(children: const [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Загружаем данные аккаунта.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Подождите, пожалуйста...',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 12,
                    ),
                  ])
                : Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        //height: 60,
                        child: TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста введите имя';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(labelText: "Имя"),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: TextFormField(
                            obscureText: _isPasswordVisible,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста введите пароль';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black38,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                labelText: "Пароль")),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : submitForm,
                          child: Text(
                            _isLoading ? 'ЗАГРУЗКА...' : 'ВОЙТИ',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(16)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                              ))),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        child: TextButton(
                          onPressed: () {
                            _launchURL();
                          },
                          child: const Text('ПОДРОБНЕЕ'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            primary: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  )
          ],
        ),
      )),
    );
  }
}
