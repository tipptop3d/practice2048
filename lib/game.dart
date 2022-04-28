import 'dart:math';

final random = Random();

enum Direction {
  left,
  right,
  up,
  down,
}

class Tile {
  static int _count = 0;
  int id;
  int value;
  Tile(this.value) : id = _count {
    _count++;
  }
  Tile.customID(this.value, this.id) {
    _count++;
  }

  void next() {
    value *= 2;
  }
}

class Board {
  final List<List<Tile?>> board;

  Board(int size)
      : board = List.generate(
          size,
          (_) => List.filled(size, null),
        );

  Board.random(int size)
      : board = List.generate(
          size,
          (_) => List.generate(
            size,
            (_) => Tile(pow(2, random.nextInt(11) + 1).toInt()),
          ),
        );

  Board.fromList(this.board);

  void populate() {
    int y, x;
    do {
      y = random.nextInt(board.length);
      x = random.nextInt(board[0].length);
    } while (board[y][x] != null);
    board[y][x] = Tile(random.nextDouble() < 0.9 ? 2 : 4);
  }

  bool canMove() {
    return canMoveLeft() || canMoveRight() || canMoveUp() || canMoveDown();
  }

  Set<Direction> possiblyDirections() {
    return {
      if (canMoveDown()) Direction.down,
      if (canMoveLeft()) Direction.left,
      if (canMoveRight()) Direction.right,
      if (canMoveUp()) Direction.up,
    };
  }

  bool canMoveLeft() {
    for (int y = 0; y < board.length; y++) {
      List<Tile?> row = board[y];
      Tile? lastTile;
      for (var tile in row.reversed) {
        if (tile == null) {
          if (lastTile != null) {
            return true;
          }
          continue;
        }
        if (tile.value == lastTile?.value) {
          return true;
        }
        lastTile = tile;
      }
    }
    return false;
  }

  void moveLeft() {
    for (int y = 0; y < board.length; y++) {
      List<Tile?> row = List<Tile?>.from(board[y]);
      row.removeWhere((tile) => tile == null);
      for (int x = 0; x < row.length - 1; x++) {
        Tile first = row[x]!;
        if (first.value == row[x + 1]!.value) {
          row[x] = first..next();
          row.removeAt(x + 1);
          x++;
        }
      }
      int zeroCount = board[0].length - row.length;
      row.addAll(List.generate(zeroCount, (_) => null));
      board[y] = row;
    }
  }

  bool canMoveRight() {
    for (int y = 0; y < board.length; y++) {
      List<Tile?> row = board[y];
      Tile? lastTile;
      for (var tile in row) {
        if (tile == null) {
          if (lastTile != null) {
            return true;
          }
          continue;
        }
        if (tile.value == lastTile?.value) {
          return true;
        }
        lastTile = tile;
      }
    }
    return false;
  }

  void moveRight() {
    for (int y = 0; y < board.length; y++) {
      List<Tile?> row = List<Tile?>.from(board[y]);
      row.removeWhere((tile) => tile == null);
      for (int x = row.length - 1; x > 0; x--) {
        Tile first = row[x]!;
        if (first.value == row[x - 1]!.value) {
          row[x] = first..next();
          row.removeAt(x - 1);
          x--;
        }
      }
      int zeroCount = board[0].length - row.length;
      row.insertAll(0, List.generate(zeroCount, (_) => null));
      board[y] = row;
    }
  }

  bool canMoveUp() {
    for (int x = 0; x < board[0].length; x++) {
      List<Tile?> column = <Tile?>[];
      for (var row in board) {
        column.add(row[x]);
      }
      Tile? lastTile;
      for (var tile in column.reversed) {
        if (tile == null) {
          if (lastTile != null) {
            return true;
          }
          continue;
        }
        if (tile.value == lastTile?.value) {
          return true;
        }
        lastTile = tile;
      }
    }
    return false;
  }

  void moveUp() {
    for (var x = 0; x < board[0].length; x++) {
      List<Tile?> column = <Tile?>[];
      for (var row in board) {
        column.add(row[x]);
      }
      column.removeWhere((tile) => tile == null);
      for (int x = 0; x < column.length - 1; x++) {
        Tile first = column[x]!;
        if (first.value == column[x + 1]!.value) {
          column[x] = first..next();
          column.removeAt(x + 1);
          x++;
        }
      }
      int zeroCount = board.length - column.length;
      column.addAll(List.filled(zeroCount, null));
      for (var y = 0; y < board.length; y++) {
        board[y][x] = column[y];
      }
    }
  }

  bool canMoveDown() {
    for (int x = 0; x < board[0].length; x++) {
      List<Tile?> column = <Tile?>[];
      for (var row in board) {
        column.add(row[x]);
      }
      Tile? lastTile;
      for (var tile in column) {
        if (tile == null) {
          if (lastTile != null) {
            return true;
          }
          continue;
        }
        if (tile.value == lastTile?.value) {
          return true;
        }
        lastTile = tile;
      }
    }
    return false;
  }

  void moveDown() {
    for (var x = 0; x < board[0].length; x++) {
      List<Tile?> column = <Tile?>[];
      for (var row in board) {
        column.add(row[x]);
      }
      column.removeWhere((tile) => tile == null);
      for (int x = column.length - 1; x > 0; x--) {
        Tile first = column[x]!;
        if (first.value == column[x - 1]!.value) {
          column[x] = first..next();
          column.removeAt(x - 1);
          x--;
        }
      }
      int zeroCount = board.length - column.length;
      column.insertAll(0, List.filled(zeroCount, null));
      for (var y = 0; y < board.length; y++) {
        board[y][x] = column[y];
      }
    }
  }

  void moveIfPossible(Direction direction) {
    switch (direction) {
      case Direction.left:
        moveLeft();
        break;
      case Direction.right:
        moveRight();
        break;
      case Direction.up:
        moveUp();
        break;
      case Direction.down:
        moveDown();
        break;
    }
  }

  void showV2() {
    print('-- 2048 BY TIPPTOP --');
    print('╔════╤════╤════╤════╗');
    String text = board.map((e) {
      var mapped = e.map((e2) {
        if (e2 == null) {
          return '    ';
        }
        String buff = (e2.id).toString();
        return ' ' * (4 - buff.length) + buff;
      }).join("│");
      return "║$mapped║";
    }).join('\n╟────┼────┼────┼────╢\n');

    print(text);

    print('╚════╧════╧════╧════╝');
  }
}

/*
-- 2048 BY TIPPTOP --
╔════╤════╤════╤════╗
║2048│2048│2048│2048║
╟────┼────┼────┼────╢
║2048│2048│2048│2048║
╟────┼────┼────┼────╢
║2048│2048│2048│2048║
╟────┼────┼────┼────╢
║2048│2048│2048│2048║
╚════╧════╧════╧════╝
*/