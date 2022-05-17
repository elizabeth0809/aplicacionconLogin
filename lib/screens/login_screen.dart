import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_formulario/provider/login_form_provider.dart';

import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
          //el singlechildscrollview hac scroll si sus hijos sobrepasan la cantidad permitida
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 250),
            CardContainer(
                child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(
                  height: 30,
                ),
                ChangeNotifierProvider(
                  create: (_) => loginFormProvider(),
                  child: _loginForm(),
                )
              ],
            )),
            SizedBox(height: 50),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'register'),
              style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(StadiumBorder())),
              child: Text(
                'Crea una nueva cuenta',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      )),
    );
  }
}

class _loginForm extends StatelessWidget {
  const _loginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<loginFormProvider>(context);
    return Container(
      child: Form(
          //esto hace que se conecte con el login_form_provider
          key: loginForm.formkey,
          //esto es para validar los datos
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            //este es un campo del formulario
            children: [
              TextFormField(
                //quita autocorreccion
                autocorrect: false,
                //tipo de campo: email
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecortions.authInputDecoration(
                    hintText: 'correo@gmail.com',
                    labelText: 'Correo Electronico',
                    prefixIcon: Icons.email),
                //esto es para tomar el valor recibido
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  //evaluar si la condicion es dada
//esto valida el correo
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);

                  //esto toma la expresion regular a ver si coincide con el campo
                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El valor no es un correo';
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  //quita autocorreccion
                  autocorrect: false,
                  //esto es para que no se vea lo que se esta escribiendo
                  obscureText: true,
                  //tipo de campo: email
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecortions.authInputDecoration(
                      hintText: 'contraseña',
                      labelText: 'Contraseña',
                      prefixIcon: Icons.lock),
                  //esto es para tomar el valor recibido
                  onChanged: (value) => loginForm.password = value,
                  validator: (value) {
                    //evaluar si la contraseña tiene 6 caracteres
                    return (value != null && value.length >= 6)
                        ? null
                        : 'La contraseña debe de ser de 6 caracteres';
                  }),
              SizedBox(height: 30),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.deepPurple,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: Text(loginForm.isLoading ? 'Espere' : 'Ingresar',
                        style: TextStyle(color: Colors.white)),
                  ),
                  onPressed: loginForm.isLoading
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final authService =
                              Provider.of<AuthService>(context, listen: false);
                          //con esto si el formulario es valido no llevara a la proxima ruta
                          if (!loginForm.isValidForm()) return;
                          loginForm.isLoading = true;
                          //validar si el login s correcto
                          final String? errorMessage = await authService.login(
                              loginForm.email, loginForm.password);
                          if (errorMessage == null) {
                            Navigator.pushReplacementNamed(context, 'home');
                          } else {
                            print(errorMessage);
                            NotificationsService.showSnackbar(errorMessage);
                            //mostrar error en pantalla
                            loginForm.isLoading = false;
                          }
                          /* //esto es para quitar el teclado
                          FocusScope.of(context).unfocus();
                          //con esto si el formulario es valido no llevara a la proxima ruta
                          if (!loginForm.isValidForm()) return;
                          loginForm.isLoading = true;
                          //esto es para que durante un tiempo no se pueda presionar
                          await Future.delayed(Duration(seconds: 2));
                          loginForm.isLoading = false;
                          Navigator.pushReplacementNamed(context, 'home');*/
                        })
            ],
          )),
    );
  }
}
