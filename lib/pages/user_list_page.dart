import 'package:flutter/material.dart';
import 'package:calculadora_imc_sqlite/helpers/database_helper.dart';

class UserListPage extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const UserListPage({Key? key, required this.dbHelper}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<Map<String, dynamic>>> userMeasurements;

  @override
  void initState() {
    super.initState();
    userMeasurements = widget.dbHelper.getMeasurements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários e IMC'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userMeasurements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final userMeasurement = snapshot.data![index];
                  return ListTile(
                    title: Text('Nome: ${userMeasurement['name']}'),
                    subtitle: Text(
                        'IMC: ${userMeasurement['imc'].toStringAsFixed(2)}'),
                    trailing: Text('Data: ${userMeasurement['date']}'),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Nenhum dado encontrado no banco de dados.'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
