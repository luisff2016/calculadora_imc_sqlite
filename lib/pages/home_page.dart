import 'package:flutter/material.dart';
import 'package:calculadora_imc_sqlite/services/calcular_imc_service.dart';
import 'package:calculadora_imc_sqlite/helpers/database_helper.dart';
import 'package:calculadora_imc_sqlite/pages/user_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  double result = 0.0;
  String classification = "";
  final CalcularIMCService calcularIMCService = CalcularIMCService();
  final DatabaseHelper dbHelper = DatabaseHelper();

  void calculateIMC() {
    final String name = nameController.text;
    final double weight = double.tryParse(weightController.text) ?? 0;
    final double height = double.tryParse(heightController.text) ?? 0;

    final double imc = calcularIMCService.calcularIMC(weight, height);
    final String classificacao = calcularIMCService.classificarIMC(imc);

    final measurement = {
      'name': name,
      'height': height,
      'weight': weight,
      'imc': imc,
      'date': DateTime.now().toString(),
    };

    dbHelper.saveMeasurement(measurement);

    setState(() {
      result = imc;
      classification = classificacao;
    });

    if (name.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Resultado para $name'),
            content: Text(
                'Seu IMC é: ${result.toStringAsFixed(2)}\nClassificação: $classification'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  void clearFields() {
    nameController.clear();
    weightController.clear();
    heightController.clear();
    setState(() {
      result = 0.0;
      classification = "";
    });
  }

  void showUserList() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserListPage(dbHelper: dbHelper),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Informe seu nome:'),
            TextField(
              controller: nameController,
            ),
            const Text('Informe seu peso (em kg):'),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
            ),
            const Text('Informe sua altura (em cm):'),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: calculateIMC,
              child: const Text('Calcular IMC'),
            ),
            Text('Seu IMC é: ${result.toStringAsFixed(2)}'),
            Text('Classificação: $classification'),
            ElevatedButton(
              onPressed: clearFields,
              child: const Text('Limpar'),
            ),
            ElevatedButton(
              onPressed: showUserList,
              child: const Text('Ver Lista'),
            ),
          ],
        ),
      ),
    );
  }
}
