import 'package:flutter/cupertino.dart';
import 'package:flutter_quiz_app/model/user_answer_model.dart';
import 'package:flutter_quiz_app/state/state_manager.dart';
import 'package:flutter_quiz_app/database/question_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void setUserAnswer(BuildContext context,MapEntry<int,Question>e,value){
  context.read(userListAnswer).state[e.key]=context.read(userAnswerSelected).state=
      new UserAnswer(questionId: e.value.questionId,
      answered: value,
      isCorrect: value
      .toString()
      .isEmpty ? value.toString().toLowerCase() ==
      e.value.correctAnswer.toLowerCase():false);
}

void showAnswer(BuildContext context){
  context.read(isEnableShowAnswer).state=true;
}