import 'package:flutter/material.dart';

class TriviaActions extends StatelessWidget {
  const TriviaActions({
    Key? key,
    required this.onConcreteNumberPressed,
    required this.onRandomNumberPressed,
  }) : super(key: key);

  final Function onConcreteNumberPressed;
  final Function onRandomNumberPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                onConcreteNumberPressed();
              },
              child: const Text('Get Concrete'),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                onRandomNumberPressed();
              },
              child: const Text('Get Random'),
            ),
          ),
        ),
      ],
    );
  }
}
