import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/database/category_provider.dart';
import 'package:flutter_quiz_app/database/db_helper.dart';
import 'package:flutter_quiz_app/database/question_provider.dart';
import 'package:flutter_quiz_app/model/user_answer_model.dart';
import 'package:flutter_quiz_app/state/state_manager.dart';
import 'package:flutter_quiz_app/utils/utils.dart';
import 'package:flutter_quiz_app/widgets/question_body.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyReadModePage extends StatefulWidget {
  MyReadModePage({Key key,this.title}):super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _MyReadModePageState();
}

class _MyReadModePageState extends State<MyReadModePage> {

  SharedPreferences prefs;
  int indexPage=0;
  CarouselController buttonCarouselController=CarouselController();

  List<UserAnswer> userAnswers = <UserAnswer>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs= await SharedPreferences.getInstance();
      indexPage= prefs.getInt('${context
          .read(questionCategoryState)
          .state
          .name}_${context
          .read(questionCategoryState)
          .state.ID}') ?? 0;
      Future.delayed(Duration(milliseconds: 500))
            .then((value) => buttonCarouselController.animateToPage(indexPage));
    });
  }
  @override
  Widget build(BuildContext context) {
    var questionModule=context.read(questionCategoryState).state;
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text(questionModule.name),
        leading: GestureDetector(
          onTap: () => showCloseDialog(questionModule),
          child: Icon(Icons.arrow_back),
      ),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Question>>(
          future: getQuestionByCategory(questionModule.ID),
          builder: (context,snapshot){
            if(snapshot.hasError)
              return Center(
                child: Text('${snapshot.error}'),);
            else if(snapshot.hasData){
              if(snapshot.data.length > 0) {
                return Container(margin: const EdgeInsets.all(4.0),
                  child: Card(
                    elevation: 8,
                    child: Container(
                        padding: const EdgeInsets.only(left: 4,
                            right: 4,
                            bottom: 4,
                            top: 10),
                        child: SingleChildScrollView(
                            child: Column(
                              children: [
                              QuestionBody(context: context,
                              carouselController: buttonCarouselController,
                              questions: snapshot.data,
                              userAnswers: userAnswers,),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                TextButton(onPressed: () => showAnswer(context),
                        child: Text('Show Answer'))
                    ],
                  )
              ],)),
            ),
        ),);
        }
           else return Center(child: Text('Category don\'t have any question'));
            } else
              return Center(
                child: CircularProgressIndicator(),);

          },
        ),
      ),
    ),
      onWillPop: () async{
      showCloseDialog(questionModule);
      return true;
    },);
  }
  showCloseDialog(Category questionModule){
    showDialog(context: context,
        builder: (_) => new AlertDialog(
          title: Text('Kapat'),
          content: Text('Bu soru endeksini kaydetmek istiyor musunuz?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();//Close dialog
              Navigator.pop(context);//Close screen
            },
                child: Text('Hayır')),
            TextButton(onPressed: (){
              prefs.setInt('${context
                  .read(questionCategoryState)
                  .state
                  .name}_${context
                  .read(questionCategoryState)
                  .state.ID}', context.read(currentReadPage).state);

              Navigator.of(context).pop();//Close dialog
              Navigator.pop(context);//Close screen
            },
              child: Text('Evet'))
          ],
        )
    );
  }

 Future<List<Question>> getQuestionByCategory(int id) async{
    var db = await copyDB();
    var result = await QuestionProvider().getQuestionByCategoryId(db, id);
    return result;
 }
}
