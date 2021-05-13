import 'package:flutter_quiz_app/database/category_provider.dart';
import 'package:flutter_quiz_app/model/user_answer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:core';


final categoryListProvider=StateNotifierProvider((ref) => new CategoryList([]));
final questionCategoryState=StateProvider((ref) => new Category());
final isTestMode=StateProvider((ref) => false);
final currentReadPage=StateProvider((ref) => 0);
final userAnswerSelected=StateProvider((ref) => new UserAnswer());
final isEnableShowAnswer=StateProvider((ref) => false);
final userListAnswer = StateProvider((ref) => <UserAnswer>[]);
