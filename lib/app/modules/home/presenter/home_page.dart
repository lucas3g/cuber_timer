import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/core_module/services/local_database/helpers/tables.dart';
import 'package:cuber_timer/app/core_module/services/local_database/local_database.dart';
import 'package:cuber_timer/app/core_module/services/local_database/params/local_database_params.dart';
import 'package:cuber_timer/app/core_module/services/local_database/schemas/record.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final localDatabase = Modular.get<ILocalDatabase>();
  final List<Record> records = [];

  void getAllRecords() async {
    final params = GetDataParams(table: Tables.records);

    final result = await localDatabase.get(params: params);

    for (var record in result) {
      records.add(Record(timer: record.timer));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.separated(
          itemBuilder: (context, index) {
            final record = records[index];

            return Text(record.timer.toString());
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: records.length,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyElevatedButtonWidget(
              width: context.screenWidth * .4,
              label: const Text('Começar'),
              onPressed: () {
                Modular.to.pushNamed('./timer/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
