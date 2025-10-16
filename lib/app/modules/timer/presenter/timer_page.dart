import 'dart:io';

import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../core/constants/constants.dart';
import '../../../core/domain/entities/named_routes.dart';
import '../../../di/dependency_injection.dart';
import '../../../shared/components/my_elevated_button_widget.dart';
import '../../../shared/services/ad_service.dart';
import '../../../shared/utils/cube_types_list.dart';
import '../../subscriptions/services/purchase_service.dart';
import '../controller/count_down_controller.dart';
import '../controller/timer_controller.dart';
import '../controller/timer_states.dart';
import 'widgets/alert_congrats_beat_record_widget.dart';
import 'widgets/list_scrambles_page.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final timerController = getIt<TimerController>();
  final countDownController = getIt<CountDownController>();
  final PurchaseService purchaseService = getIt<PurchaseService>();
  final IAdService adService = getIt<IAdService>();
  final pageController = PageController();
  int pageIndex = 0;

  bool terminated = false;

  late final ReactionDisposer _stateDisposer;

  @override
  void initState() {
    super.initState();

    _stateDisposer = autorun((_) {
      final state = timerController.state;

      if (state is BeatRecordTimerState && mounted) {
        showDialog(
          context: context,
          builder: (_) => const AlertCongratsBeatRecordWidget(),
        );
      }

      if (state is RecordLimitReachedState && mounted) {
        _showLimitReachedDialog();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!Platform.isWindows) {
        await _loadBanner();
      }
    });
  }

  late BannerAd myBanner;
  bool isAdLoaded = false;

  Future<void> _loadBanner() async {
    myBanner = await adService.loadBanner(
      androidAdId: bannerTimerPage,
      iosAdId: bannerTimerPageIdiOS,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => isAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: context.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colorScheme.errorContainer,
                    context.colorScheme.errorContainer.withOpacity(0.7),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 48,
                color: context.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              translate('timer_page.limit_reached_title'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              translate('timer_page.limit_reached_message'),
              style: TextStyle(
                fontSize: 14,
                color: context.colorScheme.onSurface.withOpacity(0.85),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                        context,
                        NamedRoutes.subscriptions.route,
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: context.colorScheme.primaryContainer,
                      foregroundColor: context.colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      translate('timer_page.limit_reached_button_upgrade'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    translate('timer_page.limit_reached_button_later'),
                    style: TextStyle(
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stateDisposer();

    if (!Platform.isWindows) {
      myBanner.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: purchaseService,
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          title: Text(translate('timer_page.title_appbar')),
          leading: BackButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                NamedRoutes.mainNavigator.route,
                (route) => false,
              );
            },
          ),
        ),
        body: Observer(
          builder: (context) {
            final state = timerController.state;

            return GestureDetector(
              onTap: () async {
                if (timerController.timer.isRunning) {
                  terminated = true;
                  setState(() {});
                  await timerController.stopTimer();
                }
              },
              onLongPress: () {
                timerController.startTimerColor();
                timerController.changeColor(Colors.yellow);
                countDownController.startTimerCountDown();
              },
              onLongPressEnd: (details) {
                if (!terminated) {
                  timerController.colorChangeTimer.cancel();

                  if (timerController.textColor == Colors.green) {
                    countDownController.stopTimerCountDown();
                    timerController.toggleTimer();
                  }

                  timerController.resetColor();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.transparent,
                width: context.screenWidth,
                height: context.screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (!Platform.isWindows && !purchaseService.isPremium) ...[
                      isAdLoaded
                          ? Column(
                              children: [
                                SizedBox(
                                  height: myBanner.size.height.toDouble(),
                                  width: myBanner.size.width.toDouble(),
                                  child: AdWidget(ad: myBanner),
                                ),
                                const SizedBox(height: 10),
                              ],
                            )
                          : const SizedBox(),
                    ],
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<int>(
                            stream: countDownController.getCountDownTimer,
                            builder: (context, snap) {
                              if (snap.hasData) {
                                final data = snap.data!;

                                return Visibility(
                                  visible:
                                      (state is StopTimerState) && !terminated,
                                  child: Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: context.screenWidth,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF151818),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    translate(
                                                      'timer_page.title_scrambles',
                                                    ),
                                                    style: context
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              ListScramblesPage(
                                                                pageController:
                                                                    pageController,
                                                                scrambles:
                                                                    timerController
                                                                        .listScrambles,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      translate(
                                                        'timer_page.textButtonListScrambles',
                                                      ),
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   translate('timer_page.text_description_how_to_change_scrambles'),
                                                  //   style:
                                                  //       context.textTheme.bodySmall,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF151818),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    translate(
                                                      'timer_page.text_description_label_group',
                                                    ),
                                                    style: context
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                      alignment:
                                                          Alignment.center,
                                                      items: CubeTypesList.types
                                                          .map((e) {
                                                            return DropdownMenuItem(
                                                              value: e,
                                                              child: Text(
                                                                e,
                                                                style: context
                                                                    .textTheme
                                                                    .bodyLarge,
                                                              ),
                                                            );
                                                          })
                                                          .toList(),
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          setState(() {
                                                            timerController
                                                                    .group =
                                                                value;
                                                          });
                                                        }
                                                      },
                                                      value:
                                                          timerController.group,
                                                      icon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          data.toString(),
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 50,
                                                color:
                                                    timerController.textColor,
                                              ),
                                        ),
                                        Text(
                                          translate(
                                            'timer_page.text_help_to_use_app',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return const Text('15');
                            },
                          ),
                          StreamBuilder(
                            stream: timerController.getTimer,
                            builder: (context, snap) {
                              if (snap.hasData) {
                                final data = snap.data!;

                                final time = StopWatchTimer.getDisplayTime(
                                  data,
                                  hours: false,
                                );

                                return Column(
                                  children: [
                                    Visibility(
                                      visible: data > 0,
                                      child: Center(
                                        child: Text(
                                          time,
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 50,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          data > 0 && (state is StopTimerState),
                                      child: MyElevatedButtonWidget(
                                        label: Text(
                                          translate(
                                            'timer_page.text_button_new_stop_watch',
                                          ),
                                        ),
                                        onPressed: () {
                                          timerController.resetTimer();
                                          countDownController
                                              .resetTimerCountDown();
                                          terminated = false;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          data > 0 &&
                                          (state is StartTimerState),
                                      child: Center(
                                        child: Text(
                                          translate(
                                            'timer_page.text_help_to_stop_timer',
                                          ),
                                          style: context.textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return const Text('00:00.0');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
