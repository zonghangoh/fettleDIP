import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'dart:io';

enum ExerciseState { PushUps, SitUps, Squats, Rest }

void audioPlayerHandler(AudioPlayerState value) => print('state => $value');

class CatTrainer extends StatefulWidget {
  final DateTime exerciseStartedAt;
  final Function endSession;
  const CatTrainer({
    Key key,
    this.endSession,
    this.exerciseStartedAt,
  }) : super(key: key);

  @override
  _CatTrainerState createState() => _CatTrainerState();
}

class _CatTrainerState extends State<CatTrainer> {
  Timer _timer;
  AudioCache audioCache;
  AudioPlayer advancedPlayer;
  ExerciseState currentExercise = ExerciseState.Rest;

  int currentRound = 0;
  int secondsElapsed = 0;
  int secondsLeftInCurrentActivity;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => widget.exerciseStartedAt != null
          ? setState(
              () {
                secondsElapsed = DateTime.now()
                    .difference(widget.exerciseStartedAt)
                    .inSeconds;
              },
            )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    advancedPlayer = AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    if (Platform.isIOS)
      advancedPlayer.monitorNotificationStateChanges(audioPlayerHandler);
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void updateExerciseState() {
    int restDurationInSeconds = 10;
    int sprintDurationInSeconds = 20;
    int activityDurationInSeconds =
        restDurationInSeconds + sprintDurationInSeconds;

    ExerciseState checkExerciseState;
    currentRound = (secondsElapsed / (3 * activityDurationInSeconds)).ceil();
    if (currentRound > 3) widget.endSession();
    int relativeSecondsElapsed =
        (secondsElapsed - (currentRound - 1) * activityDurationInSeconds * 3);

    if (relativeSecondsElapsed / activityDurationInSeconds < 1) {
      if (relativeSecondsElapsed > sprintDurationInSeconds) {
        checkExerciseState = ExerciseState.Rest;
        secondsLeftInCurrentActivity =
            activityDurationInSeconds - relativeSecondsElapsed;
      } else {
        checkExerciseState = ExerciseState.PushUps;
        secondsLeftInCurrentActivity = activityDurationInSeconds -
            restDurationInSeconds -
            relativeSecondsElapsed;
      }
    } else if (relativeSecondsElapsed / activityDurationInSeconds < 2) {
      if (relativeSecondsElapsed >
          activityDurationInSeconds + sprintDurationInSeconds) {
        checkExerciseState = ExerciseState.Rest;
        secondsLeftInCurrentActivity =
            2 * activityDurationInSeconds - relativeSecondsElapsed;
      } else {
        checkExerciseState = ExerciseState.SitUps;
        secondsLeftInCurrentActivity = 2 * activityDurationInSeconds -
            restDurationInSeconds -
            relativeSecondsElapsed;
      }
    } else {
      if (relativeSecondsElapsed >
          2 * activityDurationInSeconds + sprintDurationInSeconds) {
        checkExerciseState = ExerciseState.Rest;
        secondsLeftInCurrentActivity =
            3 * activityDurationInSeconds - relativeSecondsElapsed;
      } else {
        checkExerciseState = ExerciseState.Squats;
        secondsLeftInCurrentActivity = 3 * activityDurationInSeconds -
            restDurationInSeconds -
            relativeSecondsElapsed;
      }
    }
    if (currentRound < 4) playAudio(checkExerciseState);
  }

  void playAudio(ExerciseState exerciseState) {
    if (exerciseState != currentExercise) {
      currentExercise = exerciseState;
      if (exerciseState == ExerciseState.PushUps) {
        audioCache.play('pushups.mp3');
        // print(currentRound.toString() + ': PushUps');
      } else if (exerciseState == ExerciseState.SitUps) {
        // print(currentRound.toString() + ': Situps');
        audioCache.play('situps.mp3');
      } else if (exerciseState == ExerciseState.Squats) {
        // print(currentRound.toString() + ': Squats');
        audioCache.play('squats.mp3');
      } else {
        // print(currentRound.toString() + ': Rest');
        audioCache.play('rest.mp3');
      }
    }
  }

  Widget renderCat() {
    if (widget.exerciseStartedAt == null)
      return Container(
          height: 150,
          width: 150,
          child: Lottie.asset('assets/NormalCatBouncing.json'));

    updateExerciseState();
    LottieBuilder lottie;
    LottieBuilder nextLottie;
    double percent = 0;
    Color progressColor = currentRound == 3
        ? Colors.green
        : currentRound == 2
            ? Colors.blue
            : Colors.red;

    if (currentRound > 3) return SizedBox();
    if (currentExercise == ExerciseState.PushUps) {
      lottie = Lottie.asset("assets/pushups.json");
      nextLottie = Lottie.asset("assets/situps.json");
      percent = (20 - secondsLeftInCurrentActivity) / 20;
    } else if (currentExercise == ExerciseState.SitUps) {
      lottie = Lottie.asset("assets/situps.json");
      nextLottie = Lottie.asset("assets/squats.json");
      percent = (20 - secondsLeftInCurrentActivity) / 20;
    } else if (currentExercise == ExerciseState.Squats) {
      lottie = Lottie.asset("assets/squats.json");
      nextLottie = Lottie.asset("assets/pushups.json");
      percent = (20 - secondsLeftInCurrentActivity) / 20;
    } else {
      lottie = Lottie.asset("assets/NormalCatBouncing.json");
      percent = (10 - secondsLeftInCurrentActivity) / 10;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: new CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 10.0,
              percent: ((percent * 1.0) >= 0.0 && (percent * 1.0) <= 1.0)
                  ? (percent * 1.0)
                  : 0.0,
              center: Padding(
                padding: const EdgeInsets.all(8.0),
                child: lottie,
              ),
              progressColor: progressColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        top: MediaQuery.of(context).size.height * 0.5 - 100,
        // bottom: 0,
        child: Container(
            child: Column(
          children: [
            renderCat(),
            if (currentRound < 4)
              Text(currentRound.toString() + '/3 rounds',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))
          ],
        )));
  }
}
