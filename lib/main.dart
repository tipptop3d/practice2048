import 'package:flutter/material.dart';
import 'package:practice2048/game.dart';

void main() {
  runApp(const Game());
}

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: '2048',
      home: const Scaffold(
        body: Center(
          child: Grid2048(),
        ),
      ),
    );
  }
}

class Grid2048 extends StatefulWidget {
  const Grid2048({Key? key}) : super(key: key);

  @override
  State<Grid2048> createState() => _Grid2048State();
}

class _Grid2048State extends State<Grid2048> {
  late Board board;

  @override
  void initState() {
    board = Board(4);
    board.populate();
    board.populate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    board.showV2();
    if (!board.canMove()) {
      return const Text('You lost!');
    }

    List<Row> grid = <Row>[];
    for (var y = 0; y < board.board.length; y++) {
      List<Tile?> row = board.board[y];
      List<Widget> newRow = <Widget>[];
      for (var x = 0; x < row.length; x++) {
        var tile = row[x];
        String text = (tile?.value ?? '').toString();
        Widget tileWidget = GridTile(tile: tile, text: text);
        newRow.add(
          Flexible(fit: FlexFit.tight, child: tileWidget),
        );
      }
      grid.add(Row(
        children: newRow,
      ));
    }

    Set<Direction> possible = board.possiblyDirections();
    print(possible);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        double velocity = details.primaryVelocity ?? 0;
        print(velocity);
        if (velocity > 0 && possible.contains(Direction.right)) {
          setState(() {
            board.moveRight();
            board.populate();
          });
        }
        if (velocity < 0 && possible.contains(Direction.left)) {
          setState(() {
            board.moveLeft();
            board.populate();
          });
        }
      },
      onVerticalDragEnd: (details) {
        double velocity = details.primaryVelocity ?? 0;
        print(velocity);
        if (velocity > 0 && possible.contains(Direction.down)) {
          setState(() {
            board.moveDown();
            board.populate();
          });
        }
        if (velocity < 0 && possible.contains(Direction.up)) {
          setState(() {
            board.moveUp();
            board.populate();
          });
        }
      },
      child: SizedBox.square(
        dimension: MediaQuery.of(context).size.width,
        child: Column(children: grid),
      ),
    );
  }
}

class GridTile extends StatelessWidget {
  const GridTile({
    Key? key,
    required this.tile,
    required this.text,
  }) : super(key: key);

  final Tile? tile;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Center(
              child: Text(
            text,
            textScaleFactor: 2,
          )),
        ),
      ),
    );
  }
}

/*

*/