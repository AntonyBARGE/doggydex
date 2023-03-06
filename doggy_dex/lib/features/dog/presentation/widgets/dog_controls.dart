import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../bloc/dog_bloc.dart';

class DogControls extends StatefulWidget {
  const DogControls({
    Key? key,
  }) : super(key: key);

  @override
  State<DogControls> createState() => _DogControlsState();
}

class _DogControlsState extends State<DogControls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          onSubmitted:  (_) {
            addConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: addConcrete,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade500,
                ),
                onPressed: addRandom,
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void addConcrete() {
    controller.clear();
    context.read<DogBloc>().add(GetConcreteDogEvent(inputStr));
  }

  void addRandom() {
    controller.clear();
    context.read<DogBloc>().add(GetRandomDogEvent());
  }
}
