import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './quiz.dart';
import './answer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white
      ),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Quiz quiz;
  List<Results> results;
  Future<void> fetchQuestions() async {
    var res = await http.get('https://opentdb.com/api.php?amount=20');
    var decRes = jsonDecode(res.body);
    print(decRes);
    quiz = Quiz.fromJson(decRes);
    results = quiz.results;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
        elevation: 0.0,
      ),
    body: RefreshIndicator(
       onRefresh: fetchQuestions,
      child: FutureBuilder(
        future:  fetchQuestions(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            return Text('Press button to start');
            case ConnectionState.active:
            case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(),);
            case ConnectionState.done:
            if(snapshot.hasError) return errorData(snapshot);
            return questionList();
          }
          return null;
        },
      ),
    ),
    );
  }
  Padding errorData(AsyncSnapshot snapshot) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${snapshot.error}'),
          SizedBox(height: 20.0,),
          RaisedButton(
            onPressed: () {
              fetchQuestions();
              setState(() {});
            },
            child: Text('Try Again'),
         ),
        ],
      ),
    );
  }
  ListView questionList() {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => Card(
        color:  Colors.white,
        elevation: 0.0,
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(results[index].question,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterChip(
                        backgroundColor: Colors.grey[100],
                        label: Text(results[index].category), 
                        onSelected: (b) {}
                      ),
                      SizedBox(width: 10.0,),
                      FilterChip(
                        backgroundColor: Colors.grey[100],
                        label: Text(results[index].difficulty), 
                        onSelected: (b) {}
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: Text(results[index].type.startsWith('m') ? 'M' : 'B'),
          ),
          children: results[index].allAnswers.map((answers) {
            return AnswerWidget(results, index, answers);
          }).toList(),
        ),
      ),
    );
  }
}
