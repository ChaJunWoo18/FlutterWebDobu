import 'package:flutter/material.dart';
import 'package:prob/provider/graph_provider.dart';
import 'package:prob/provider/home_provider.dart';
import 'package:prob/widgets/graph/bar/chart.dart';
import 'package:provider/provider.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});
  static const preButton = 'assets/images/pre_button.png';
  static const graphImage = 'assets/images/graph.png';

  @override
  Widget build(BuildContext context) {
    //final graphProvider = context.read<GraphProvider>();
    final homeProvider = context.read<HomeProvider>();
    final maxHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).size.height / 5;
    final graphHeight = maxHeight - 200;
    return Container(
      height: maxHeight,
      color: const Color(0xFFFFFBF5),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GraphHeader(
                  homeProvider: homeProvider,
                  preButton: preButton,
                  graphImage: graphImage),
              const SizedBox(height: 40),
              Container(
                height: graphHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFC19F64)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Chart(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GraphHeader extends StatelessWidget {
  const GraphHeader({
    super.key,
    required this.homeProvider,
    required this.preButton,
    required this.graphImage,
  });
  final HomeProvider homeProvider;
  final String preButton;
  final String graphImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          style: const ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          onPressed: () {
            homeProvider.setHomeWidget('mainPage');
          },
          child: SizedBox(
            width: 24,
            child: Image.asset(preButton),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Transform.scale(
              scale: 13,
              child: Transform.rotate(
                angle: 0.2,
                child: Image.asset(
                  graphImage,
                  width: 10,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
