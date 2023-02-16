import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/dog_bloc.dart';
import '../bloc/dog_event.dart';

class DogControls extends StatefulWidget {
  const DogControls({
    Key? key,
  }) : super(key: key);

  @override
  _DogControlsState createState() => _DogControlsState();
}

class _DogControlsState extends State<DogControls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchConcrete,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                child: const Text('Get random dog'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<DogBloc>(context)
        .add(GetConcreteDogEvent(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<DogBloc>(context).add(GetRandomDogEvent());
  }
}
