import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_states.dart';
import 'package:cuber_timer/app/modules/home/presenter/widgets/card_record_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class AllRecordsByGroupPage extends StatefulWidget {
  const AllRecordsByGroupPage({super.key});

  @override
  State<AllRecordsByGroupPage> createState() => _AllRecordsByGroupPageState();
}

class _AllRecordsByGroupPageState extends State<AllRecordsByGroupPage> {
  final RecordController recordController = getIt<RecordController>();

  late final String? groupArg;

  Future<void> _getAllRecordsByGroup(String group) async {
    await recordController.getAllRecordsByGroup(group);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getAllRecordsByGroup(groupArg!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupArg =
        (ModalRoute.of(context)!.settings.arguments as Map)['group'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate.timerPage.titleAppBarMoreRecords,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Observer(
          builder: (_) {
            final state = recordController.state;

            if (state is LoadingListRecordState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ErrorRecordState) {
              return Center(child: Text(state.message));
            }

            if (state is SuccessGetListRecordState) {
              final records = state.records;

              if (records.isEmpty) {
                return Center(
                  child: Text(context.translate.homePage.listEmpty),
                );
              }

              return Column(
                children: [
                  Text(
                    groupArg == null
                        ? context.translate.timerPage.textGroupByModelLoading
                        : '${context.translate.timerPage.textGroupByModel}: $groupArg',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: SuperListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];

                        final color = [
                          Colors.amber,
                          Colors.green,
                          Colors.blue,
                          Colors.red,
                        ].elementAt(index.clamp(0, 3));

                        final fontSize = [
                          24.0,
                          22.0,
                          20.0,
                          18.0,
                        ].elementAt(index.clamp(0, 3));

                        return CardRecordWidget(
                          recordController: recordController,
                          index: index,
                          recordEntity: record,
                          colorText: color,
                          fontSize: fontSize,
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text('Estado desconhecido.'),
            );
          },
        ),
      ),
    );
  }
}
