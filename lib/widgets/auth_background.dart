import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(),
          this.child,
          //este container es para poner el icono
          SafeArea(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 30),
              child: Icon(
                Icons.perm_identity_outlined,
                color: Colors.white,
                size: 100,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      //gradiente
      decoration: _purpleBackground(),
      //circulos superpuestos
      child: Stack(
        //el positioned es para mover el circulo de posiscion
        children: [
          Positioned(
            child: _Bubble(),
            top: -20,
            left: -30,
          ),
          Positioned(
            child: _Bubble(),
            top: 250,
            left: -10,
          ),
          Positioned(
            child: _Bubble(),
            top: 70,
            left: 300,
          ),
          Positioned(
            child: _Bubble(),
            top: 270,
            left: 230,
          ),
          Positioned(
            child: _Bubble(),
            top: 100,
            left: 50,
          )
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]));
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
