import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../injection_container.dart';
import '../bloc/bloc.dart';
import '../widgets/dog_controls.dart';
import '../widgets/dog_display.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class DogPage extends StatelessWidget {
  const DogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<DogBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DogBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              // Top half
              BlocBuilder<DogBloc, DogState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return DogDisplay(dog: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    throw CacheException();
                  }
                },
              ),
              const SizedBox(height: 20),
              // Bottom half
              const DogControls()
            ],
          ),
        ),
      ),
    );
  }
}
