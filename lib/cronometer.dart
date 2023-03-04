import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cronometer extends StatefulWidget {
  const Cronometer({super.key});

  @override
  State<Cronometer> createState() => _CronometerState();
}

class _CronometerState extends State<Cronometer> {
  int milisegundos = 0;
  bool estaCorriendo = false;
  late Timer timer;
  List laps = [];
  void iniciarCronometro(){
    if (!estaCorriendo) {
      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        // ignore: unnecessary_this
        this.milisegundos += 10;
        setState(() {});
      });
      estaCorriendo = true;    
    }
  }

  void detenerCronometro(){
    if (estaCorriendo) {      
      timer.cancel();
      estaCorriendo = false;
      setState(() {});
    }
  }

  void reiniciarCronometro(){   
      setState(() {
        // ignore: unnecessary_this
        this.milisegundos = 0;
        laps.clear();
      });
  }

  void vueltaCronometro(){
    if (laps.isNotEmpty) {
      String lap = formatearDiferenciaTiempo(laps.last);
      setState(() {
        laps.add(lap);
      });
    } else {
      String lap = formatearTiempo();
      setState(() {
        laps.add(lap);
      });
    }
  }

  String formatearDiferenciaTiempo(String lapAnterior){
    Duration duracionAnterior = Duration(
      hours: int.parse(lapAnterior.substring(0,2)),
      minutes: int.parse(lapAnterior.substring(3,5)),
      seconds: int.parse(lapAnterior.substring(6,8)),
      milliseconds: int.parse(lapAnterior.substring(9,11)) * 10,
    );

    Duration duracionActual = Duration(milliseconds: this.milisegundos);
    Duration diferencia = duracionActual - duracionAnterior;

    String dosValores(int valor){
      return valor >= 10 ? "$valor" : "0$valor";
    }

    String horas = dosValores(diferencia.inHours);
    String minutos = dosValores(diferencia.inMinutes.remainder(60));
    String segundos = dosValores(diferencia.inSeconds.remainder(60));
    String milisegundos = dosValores(diferencia.inMilliseconds.remainder(1000)).substring(0,2);

    return "$horas:$minutos:$segundos:$milisegundos";
  }

  String formatearTiempo(){
    Duration duracion = Duration(milliseconds: this.milisegundos);

    String dosValores(int valor){
      return valor >= 10 ? "$valor" : "0$valor";
    }

    String horas = dosValores(duracion.inHours);
    String minutos = dosValores(duracion.inMinutes.remainder(60));
    String segundos = dosValores(duracion.inSeconds.remainder(60));
    String milisegundos = dosValores(duracion.inMilliseconds.remainder(1000)).substring(0,2);
    return "$horas:$minutos:$segundos:$milisegundos";
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatearTiempo(), 
          style: const TextStyle(fontSize: 50, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoButton(onPressed: iniciarCronometro, child: const Icon(Icons.not_started_outlined, size: 50, color: Colors.lightGreen,)),
            CupertinoButton(onPressed: vueltaCronometro,  child: const Icon(Icons.redo_outlined, size: 50, color: Colors.amberAccent,)),
            CupertinoButton(onPressed: detenerCronometro, child: const Icon(Icons.stop_circle_outlined, size: 50, color: Colors.red,))
          ],
        ),
        CupertinoButton(onPressed: reiniciarCronometro, child: const Text("Restablecer"),),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          height: 300,
          width: 400,
          decoration: BoxDecoration(
            color: const Color(0xFF323F68),
            borderRadius: BorderRadius.circular(8.0)
          ),
          child: ListView.builder(
            itemCount: laps.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Lap Nº ${index + 1}",style: const TextStyle(color: Colors.white, fontSize: 16.0),),
                    Text("${laps[index]}",style: const TextStyle(color: Colors.white, fontSize: 16.0),)
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}