class CalcularIMCService {
  double calcularIMC(double peso, double altura) {
    final imc = peso / (altura * altura);
    return imc;
  }

  String classificarIMC(double imc) {
    if (imc < 16.0) {
      return "Magreza grave";
    } else if (imc < 16.9) {
      return "Magreza moderada";
    } else if (imc < 18.4) {
      return "Magreza leve";
    } else if (imc < 24.9) {
      return "Saudável";
    } else if (imc < 29.9) {
      return "Sobrepeso";
    } else if (imc < 34.9) {
      return "Obesidade Grau I";
    } else if (imc < 40.0) {
      return "Obesidade Grau II (severa)";
    } else {
      return "Obesidade Grau III (mórbida)";
    }
  }
}
