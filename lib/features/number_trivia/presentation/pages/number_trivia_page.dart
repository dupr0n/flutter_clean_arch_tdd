import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/trivia_controls.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return MessageDisplay('Start searching!');
                      } else if (state is Loading) {
                        return LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(state.trivia);
                      } else if (state is Error) {
                        return MessageDisplay(state.message);
                      } else {
                        return MessageDisplay('Something went wrong');
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  //* Bottom half
                  TriviaControls()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
