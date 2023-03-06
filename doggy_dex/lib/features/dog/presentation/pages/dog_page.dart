import '../bloc/dog_bloc.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class DogPage extends StatelessWidget {
  const DogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dog'),
        ),
        body: SingleChildScrollView(
          child: buildBody(context)));
  }

  BlocProvider<DogBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DogBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BlocBuilder<DogBloc, DogState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(message: 'Start searching');
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return DogDisplay(dog: state.dog);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: const Placeholder(),
                  );
                },
              ),
              const SizedBox(height: 20),
              const DogControls(),
            ],
          ),
        ),
      ),
    );
  }
}

