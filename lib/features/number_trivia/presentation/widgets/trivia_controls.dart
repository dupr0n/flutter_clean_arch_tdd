import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a Number',
          ),
          keyboardType: TextInputType.number,
          onSubmitted: (_) => dispatchConcrete(),
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetNumberTriviaForConcreteNumber(controller.text));
    controller.clear();
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetNumberTriviaForRandomNumber());
  }
}
