// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_states.dart';
import 'package:cuber_timer/app/modules/home/presenter/widgets/card_record_widget.dart';
import 'package:cuber_timer/app/shared/components/my_circular_progress_widget.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:cuber_timer/app/shared/components/my_snackbar.dart';
import 'package:cuber_timer/app/shared/components/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class HomePage extends StatefulWidget {
  final RecordController recordController;
  const HomePage({
    Key? key,
    required this.recordController,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getAllRecords() async {
    await widget.recordController.getAllRecords();
  }

  @override
  void initState() {
    super.initState();

    getAllRecords();

    autorun((_) {
      final state = widget.recordController.state;

      if (state is ErrorRecordState) {
        MySnackBar(
          title: 'Opss...',
          message: state.message,
          type: TypeSnack.error,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Cube Timer',
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: ThemeModeController.appStore.changeThemeMode,
      //       icon: Icon(
      //         ThemeModeController.themeMode == ThemeMode.dark
      //             ? Icons.light_mode
      //             : Icons.dark_mode,
      //       ),
      //     )
      //   ],
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Observer(builder: (context) {
                final state = widget.recordController.state;

                if (state is! SuccessGetListRecordState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyCircularProgressWidget(),
                      Text(
                        context.translate.homePage.textLoading,
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  );
                }

                final records = state.records;

                if (records.isEmpty) {
                  return NoDataWidget(
                      text: context.translate.homePage.listEmpty);
                }

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: context.myTheme.onBackground,
                              ),
                            ),
                          ),
                          child: Text(
                            context.translate.homePage.titleList,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final record = records[index];

                            if (index == 0) {
                              return CardRecordWidget(
                                recordController: widget.recordController,
                                index: index,
                                recordEntity: record,
                                colorText: Colors.amber,
                                fontSize: 20,
                              );
                            }

                            if (index == 1) {
                              return CardRecordWidget(
                                recordController: widget.recordController,
                                index: index,
                                recordEntity: record,
                                colorText: Colors.green,
                                fontSize: 18,
                              );
                            }

                            if (index == 2) {
                              return CardRecordWidget(
                                recordController: widget.recordController,
                                index: index,
                                recordEntity: record,
                                colorText: Colors.blue,
                                fontSize: 16,
                              );
                            }

                            return CardRecordWidget(
                              recordController: widget.recordController,
                              index: index,
                              recordEntity: record,
                              colorText: context.myTheme.onBackground,
                              fontSize: 14,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemCount: records.length,
                        ),
                      ),
                      Divider(
                        color: context.myTheme.onBackground,
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: context.myTheme.onBackground,
                              ),
                            ),
                          ),
                          child: Text(
                            context.translate.homePage.titleAvg,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                context.translate.homePage.best,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              Text(
                                StopWatchTimer.getDisplayTime(
                                  widget.recordController.bestTime,
                                  hours: false,
                                ),
                                style: context.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                context.translate.homePage.avg5,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                StopWatchTimer.getDisplayTime(
                                  widget.recordController.avgFive,
                                  hours: false,
                                ),
                                style: context.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                context.translate.homePage.avg12,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                StopWatchTimer.getDisplayTime(
                                  widget.recordController.avgTwelve,
                                  hours: false,
                                ),
                                style: context.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: context.myTheme.onBackground,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Observer(builder: (context) {
                final state = widget.recordController.state;
                if (state is! SuccessGetListRecordState) {
                  return const SizedBox();
                }

                return Column(
                  children: [
                    MyElevatedButtonWidget(
                      width: context.screenWidth * .4,
                      label: Text(context.translate.homePage.buttonStart),
                      onPressed: () async {
                        await Modular.to.pushNamed('./timer/');
                        await getAllRecords();
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
