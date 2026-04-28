// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:math';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Fruity Merge',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF6366F1),
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//         scaffoldBackgroundColor: const Color(0xFF0A0A0A),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.transparent,
//           foregroundColor: Colors.white70,
//           elevation: 0,
//           centerTitle: true,
//           titleTextStyle: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.5,
//           ),
//         ),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: Colors.white70,
//           ),
//           bodyMedium: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: Colors.white60,
//           ),
//           labelLarge: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       home: const GameScreen(),
//     );
//   }
// }

// class GameScreen extends StatefulWidget {
//   const GameScreen({super.key});

//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
//   late GameBoard gameBoard;
//   late Tile nextTile;
//   int score = 0;
//   bool isDropInProgress = false;
//   bool hasPlacedFirstTile = false;
//   bool isGameOver = false;
//   final GlobalKey<_GameBoardWidgetState> _gameBoardKey =
//       GlobalKey<_GameBoardWidgetState>();

//   @override
//   void initState() {
//     super.initState();
//     gameBoard = GameBoard(8, 6, this);
//     nextTile = _generateRandomTile();
//   }

//   Tile _generateRandomTile() {
//     final randomLevel = Random().nextInt(3) + 1;
//     return Tile(
//       level: randomLevel,
//       emoji: Tile.emojis[randomLevel - 1],
//       color: Tile.colors[randomLevel - 1],
//     );
//   }

//   void _onColumnTapped(int col) {
//     if (isDropInProgress || isGameOver) return;
//     final targetRow = gameBoard.findDropRow(col);
//     if (targetRow < 0) {
//       if (gameBoard.isBoardFull()) {
//         _handleGameOver();
//       }
//       return;
//     }
//     setState(() {
//       isDropInProgress = true;
//       hasPlacedFirstTile = true;
//     });
//     final fallingTile = FallingTile(nextTile, 0, col, targetRow, this);
//     _gameBoardKey.currentState!.addFallingTile(fallingTile);
//   }

//   void _resetGame() {
//     setState(() {
//       gameBoard = GameBoard(8, 6, this);
//       nextTile = _generateRandomTile();
//       score = 0;
//       isDropInProgress = false;
//       hasPlacedFirstTile = false;
//       isGameOver = false;
//     });
//   }

//   Future<void> _shareScore() async {
//     final message = 'Fruity Merge 점수: $score점!\n너도 도전해봐!';
//     await SharePlus.instance.share(
//       ShareParams(text: message, subject: 'Fruity Merge 점수 공유'),
//     );
//   }

//   Future<void> _handleGameOver() async {
//     if (!mounted || isGameOver) return;
//     setState(() {
//       isGameOver = true;
//       isDropInProgress = false;
//     });

//     await showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: const Color.fromRGBO(255, 255, 255, 0.08),
//           surfaceTintColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.2)),
//           ),
//           title: const Text(
//             'Game Over',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           content: Text(
//             '더 이상 놓을 칸이 없어요.\n최종 점수: $score점',
//             style: const TextStyle(fontSize: 16, color: Colors.white70),
//             textAlign: TextAlign.center,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await _shareScore();
//               },
//               style: TextButton.styleFrom(foregroundColor: Colors.white70),
//               child: const Text('점수 공유'),
//             ),
//             FilledButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _resetGame();
//               },
//               style: FilledButton.styleFrom(
//                 backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('다시하기'),
//             ),
//           ],
//           actionsAlignment: MainAxisAlignment.spaceEvenly,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'FRUITY MERGE',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         bottom: false,
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 16,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(255, 255, 255, 0.05),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: const Color.fromRGBO(255, 255, 255, 0.1),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color.fromRGBO(0, 0, 0, 0.2),
//                               blurRadius: 10,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     'SCORE',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.white60,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Text(
//                                     '$score',
//                                     style: const TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 1,
//                               height: 48,
//                               margin: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                               ),
//                               color: const Color.fromRGBO(255, 255, 255, 0.1),
//                             ),
//                             const Text(
//                               'NEXT',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white60,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 color: nextTile.color,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   nextTile.emoji,
//                                   style: const TextStyle(fontSize: 32),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromRGBO(
//                                   255,
//                                   255,
//                                   255,
//                                   0.05,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                   color: const Color.fromRGBO(
//                                     255,
//                                     255,
//                                     255,
//                                     0.1,
//                                   ),
//                                 ),
//                               ),
//                               child: Text(
//                                 'Lv ${nextTile.level}',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 300),
//                       child: !hasPlacedFirstTile
//                           ? Container(
//                               key: const ValueKey('board_tap_hint'),
//                               margin: const EdgeInsets.only(bottom: 12),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromRGBO(
//                                   255,
//                                   255,
//                                   255,
//                                   0.03,
//                                 ),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: const Color.fromRGBO(
//                                     255,
//                                     255,
//                                     255,
//                                     0.2,
//                                   ),
//                                 ),
//                               ),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.touch_app_rounded,
//                                     size: 18,
//                                     color: Colors.white70,
//                                   ),
//                                   SizedBox(width: 8),
//                                   Text(
//                                     '보드에서 원하는 칸을 탭하면 과일이 떨어져요',
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : const SizedBox.shrink(),
//                     ),
//                     // 게임판
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: GameBoardWidget(
//                           key: _gameBoardKey,
//                           gameBoard: gameBoard,
//                           onColumnTapped: _onColumnTapped,
//                           isInputEnabled: !isDropInProgress && !isGameOver,
//                           onTileDropped: (ft) {
//                             setState(() {
//                               score += gameBoard.handleDroppedTile(
//                                 ft.tile,
//                                 ft.col,
//                               );
//                               nextTile = _generateRandomTile();
//                               isDropInProgress = false;
//                             });
//                             if (gameBoard.isBoardFull()) {
//                               _handleGameOver();
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class GameBoardWidget extends StatefulWidget {
//   final GameBoard gameBoard;
//   final Function(int) onColumnTapped;
//   final Function(FallingTile) onTileDropped;
//   final bool isInputEnabled;

//   const GameBoardWidget({
//     super.key,
//     required this.gameBoard,
//     required this.onColumnTapped,
//     required this.onTileDropped,
//     required this.isInputEnabled,
//   });

//   @override
//   State<GameBoardWidget> createState() => _GameBoardWidgetState();
// }

// class _GameBoardWidgetState extends State<GameBoardWidget>
//     with TickerProviderStateMixin {
//   List<FallingTile> fallingTiles = [];
//   late AnimationController _shakeController;
//   late Animation<double> _shakeAnimation;
//   double _shakeAmplitude = 0;

//   @override
//   void initState() {
//     super.initState();
//     _shakeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 170),
//     );
//     _shakeAnimation = CurvedAnimation(
//       parent: _shakeController,
//       curve: Curves.easeOut,
//     );
//     widget.gameBoard.onVisualStateChanged = _refreshBoard;
//     widget.gameBoard.onMergeTriggered = _handleMergeTriggered;
//   }

//   @override
//   void didUpdateWidget(covariant GameBoardWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (!identical(oldWidget.gameBoard, widget.gameBoard)) {
//       oldWidget.gameBoard.onVisualStateChanged = null;
//       oldWidget.gameBoard.onMergeTriggered = null;
//       widget.gameBoard.onVisualStateChanged = _refreshBoard;
//       widget.gameBoard.onMergeTriggered = _handleMergeTriggered;
//     }
//   }

//   @override
//   void dispose() {
//     widget.gameBoard.onVisualStateChanged = null;
//     widget.gameBoard.onMergeTriggered = null;
//     _shakeController.dispose();
//     super.dispose();
//   }

//   void _refreshBoard() {
//     if (!mounted) return;
//     setState(() {});
//   }

//   void _handleMergeTriggered(MergeEvent event) {
//     _shakeAmplitude = (0.7 + event.level * 0.28).clamp(0.7, 3.0).toDouble();
//     _shakeController.forward(from: 0);
//   }

//   void addFallingTile(FallingTile ft) {
//     setState(() {
//       fallingTiles.add(ft);
//     });
//     ft.start().then((_) {
//       setState(() {
//         fallingTiles.remove(ft);
//         widget.onTileDropped(ft);
//       });
//     });
//   }

//   void _onColumnTapped(int col) {
//     if (!widget.isInputEnabled) return;
//     widget.onColumnTapped(col);
//   }

//   void _onBoardTapDown(TapDownDetails details, BoxConstraints constraints) {
//     if (!widget.isInputEnabled) return;
//     const double gridPadding = 8;
//     const double gridSpacing = 8;
//     final cols = widget.gameBoard.cols;
//     final boardContentWidth = constraints.maxWidth - (gridPadding * 2);
//     if (boardContentWidth <= 0) return;
//     final cellWidth = (boardContentWidth - (gridSpacing * (cols - 1))) / cols;
//     final x = details.localPosition.dx - gridPadding;
//     if (x < 0 || x > boardContentWidth) return;
//     final col = (x / (cellWidth + gridSpacing)).floor().clamp(0, cols - 1);
//     _onColumnTapped(col);
//   }

//   @override
//   Widget build(BuildContext context) {
//     const double gridPadding = 8;
//     const double gridSpacing = 8;

//     return AnimatedBuilder(
//       animation: _shakeAnimation,
//       builder: (context, child) {
//         final t = _shakeAnimation.value;
//         final decay = (1 - t);
//         final dx = sin(t * pi * 10) * _shakeAmplitude * decay;
//         final dy = sin(t * pi * 6) * (_shakeAmplitude * 0.35) * decay;
//         return Transform.translate(offset: Offset(dx, dy), child: child);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF111827), Color(0xFF0B1120)],
//           ),
//           border: Border.all(color: const Color(0xFF7C3AED), width: 2),
//           borderRadius: BorderRadius.circular(6),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x99000000),
//               blurRadius: 0,
//               offset: Offset(5, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // 게임판 그리드
//             Expanded(
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   final cellWidth =
//                       (constraints.maxWidth -
//                           (gridPadding * 2) -
//                           (gridSpacing * (widget.gameBoard.cols - 1))) /
//                       widget.gameBoard.cols;
//                   final cellHeight = cellWidth;

//                   return GestureDetector(
//                     behavior: HitTestBehavior.opaque,
//                     onTapDown: (details) =>
//                         _onBoardTapDown(details, constraints),
//                     child: Stack(
//                       children: [
//                         GridView.builder(
//                           padding: const EdgeInsets.all(gridPadding),
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: widget.gameBoard.cols,
//                                 crossAxisSpacing: gridSpacing,
//                                 mainAxisSpacing: gridSpacing,
//                               ),
//                           itemCount:
//                               widget.gameBoard.rows * widget.gameBoard.cols,
//                           itemBuilder: (context, index) {
//                             final row = index ~/ widget.gameBoard.cols;
//                             final col = index % widget.gameBoard.cols;
//                             final tile = widget.gameBoard.getTile(row, col);
//                             final isMerging = widget.gameBoard.mergingTiles.any(
//                               (mt) => mt.row == row && mt.col == col,
//                             );
//                             final isDisappearing = widget
//                                 .gameBoard
//                                 .disappearingTiles
//                                 .any((dt) => dt.row == row && dt.col == col);

//                             if (isMerging || isDisappearing) {
//                               return Container(); // 애니메이션 중에는 GridView에서 표시하지 않음
//                             }

//                             return TileWidget(tile: tile);
//                           },
//                         ),
//                         // 떨어지는 타일들
//                         ...fallingTiles.map(
//                           (ft) => AnimatedBuilder(
//                             animation: ft.animation,
//                             builder: (context, child) {
//                               final startY = -cellHeight; // 위쪽에서 시작
//                               final endY =
//                                   ft.targetRow * (cellHeight + gridSpacing) +
//                                   gridPadding;
//                               final currentY =
//                                   startY + ft.animation.value * (endY - startY);

//                               return Positioned(
//                                 left:
//                                     ft.col * (cellWidth + gridSpacing) +
//                                     gridPadding,
//                                 top: currentY,
//                                 width: cellWidth,
//                                 height: cellHeight,
//                                 child: TileWidget(tile: ft.tile),
//                               );
//                             },
//                           ),
//                         ),
//                         // 사라지는 타일들
//                         ...widget.gameBoard.disappearingTiles.map(
//                           (dt) => AnimatedBuilder(
//                             animation: dt.opacity,
//                             builder: (context, child) {
//                               return Positioned(
//                                 left:
//                                     dt.col * (cellWidth + gridSpacing) +
//                                     gridPadding,
//                                 top:
//                                     dt.row * (cellHeight + gridSpacing) +
//                                     gridPadding,
//                                 width: cellWidth,
//                                 height: cellHeight,
//                                 child: Opacity(
//                                   opacity: dt.opacity.value,
//                                   child: TileWidget(tile: dt.tile),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         // 병합되는 타일들
//                         ...widget.gameBoard.mergingTiles.map(
//                           (mt) => AnimatedBuilder(
//                             animation: mt.scale,
//                             builder: (context, child) {
//                               return Positioned(
//                                 left:
//                                     mt.col * (cellWidth + gridSpacing) +
//                                     gridPadding,
//                                 top:
//                                     mt.row * (cellHeight + gridSpacing) +
//                                     gridPadding,
//                                 width: cellWidth,
//                                 height: cellHeight,
//                                 child: Center(
//                                   child: Transform.scale(
//                                     scale: mt.scale.value,
//                                     alignment: Alignment.center,
//                                     child: SizedBox(
//                                       width: cellWidth,
//                                       height: cellHeight,
//                                       child: TileWidget(tile: mt.tile),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         // 병합 이펙트(레벨 비례 링 + 파티클)
//                         ...widget.gameBoard.mergeBurstEffects.map(
//                           (effect) => AnimatedBuilder(
//                             animation: effect.progress,
//                             builder: (context, child) {
//                               return Positioned(
//                                 left:
//                                     effect.col * (cellWidth + gridSpacing) +
//                                     gridPadding,
//                                 top:
//                                     effect.row * (cellHeight + gridSpacing) +
//                                     gridPadding,
//                                 width: cellWidth,
//                                 height: cellHeight,
//                                 child: IgnorePointer(
//                                   child: _MergeBurstWidget(
//                                     tile: effect.tile,
//                                     progress: effect.progress.value,
//                                     intensity: effect.intensity,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         // 점수 플로팅 텍스트
//                         ...widget.gameBoard.floatingScoreEffects.map(
//                           (effect) => AnimatedBuilder(
//                             animation: effect.progress,
//                             builder: (context, child) {
//                               return Positioned(
//                                 left:
//                                     effect.col * (cellWidth + gridSpacing) +
//                                     gridPadding,
//                                 top:
//                                     effect.row * (cellHeight + gridSpacing) +
//                                     gridPadding,
//                                 width: cellWidth,
//                                 height: cellHeight,
//                                 child: IgnorePointer(
//                                   child: Center(
//                                     child: _FloatingScoreWidget(
//                                       points: effect.points,
//                                       level: effect.level,
//                                       progress: effect.progress.value,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FallingTile {
//   final Tile tile;
//   final int startRow;
//   final int col;
//   final int targetRow;
//   late AnimationController controller;
//   late Animation<double> animation;
//   static const int _millisecondsPerCell = 93;

//   FallingTile(
//     this.tile,
//     this.startRow,
//     this.col,
//     this.targetRow,
//     TickerProvider vsync,
//   ) {
//     final travelCells = (targetRow - startRow + 1).clamp(1, 999);
//     final durationMs = (travelCells * _millisecondsPerCell).clamp(70, 420);
//     controller = AnimationController(
//       vsync: vsync,
//       duration: Duration(milliseconds: durationMs),
//     );
//     animation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
//   }

//   Future<void> start() async {
//     await controller.forward();
//   }
// }

// class MergingTile {
//   final int row;
//   final int col;
//   final Tile tile;
//   final GameBoard gameBoard;
//   late AnimationController controller;
//   late Animation<double> scale;

//   MergingTile(
//     this.row,
//     this.col,
//     this.tile,
//     TickerProvider vsync,
//     this.gameBoard,
//   ) {
//     controller = AnimationController(
//       vsync: vsync,
//       duration: const Duration(milliseconds: 360),
//     );
//     scale = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: 1.0,
//           end: 1.2,
//         ).chain(CurveTween(curve: Curves.easeOut)),
//         weight: 55,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: 1.2,
//           end: 1.0,
//         ).chain(CurveTween(curve: Curves.easeIn)),
//         weight: 45,
//       ),
//     ]).animate(controller);
//     controller.forward().then((_) {
//       gameBoard.removeMergingTile(this);
//     });
//   }
// }

// class DisappearingTile {
//   final int row;
//   final int col;
//   final Tile tile;
//   final GameBoard gameBoard;
//   late AnimationController controller;
//   late Animation<double> opacity;

//   DisappearingTile(
//     this.row,
//     this.col,
//     this.tile,
//     TickerProvider vsync,
//     this.gameBoard,
//   ) {
//     controller = AnimationController(
//       vsync: vsync,
//       duration: const Duration(milliseconds: 50),
//     );
//     opacity = Tween<double>(begin: 1, end: 0).animate(controller);
//     controller.forward().then((_) {
//       gameBoard.removeDisappearingTile(this);
//     });
//   }
// }

// class MergeBurstEffect {
//   final int row;
//   final int col;
//   final Tile tile;
//   final double intensity;
//   final GameBoard gameBoard;
//   late AnimationController controller;
//   late Animation<double> progress;

//   MergeBurstEffect(
//     this.row,
//     this.col,
//     this.tile,
//     TickerProvider vsync,
//     this.gameBoard,
//   ) : intensity = (0.9 + tile.level * 0.14).clamp(0.9, 2.0).toDouble() {
//     controller = AnimationController(
//       vsync: vsync,
//       duration: const Duration(milliseconds: 420),
//     );
//     progress = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
//     controller.forward().then((_) {
//       gameBoard.removeMergeBurstEffect(this);
//     });
//   }
// }

// class FloatingScoreEffect {
//   final int row;
//   final int col;
//   final int points;
//   final int level;
//   final GameBoard gameBoard;
//   late AnimationController controller;
//   late Animation<double> progress;

//   FloatingScoreEffect(
//     this.row,
//     this.col,
//     this.points,
//     this.level,
//     TickerProvider vsync,
//     this.gameBoard,
//   ) {
//     controller = AnimationController(
//       vsync: vsync,
//       duration: const Duration(milliseconds: 700),
//     );
//     progress = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
//     controller.forward().then((_) {
//       gameBoard.removeFloatingScoreEffect(this);
//     });
//   }
// }

// class MergeEvent {
//   final int row;
//   final int col;
//   final int level;
//   final int points;

//   const MergeEvent({
//     required this.row,
//     required this.col,
//     required this.level,
//     required this.points,
//   });
// }

// class _MergeBurstWidget extends StatelessWidget {
//   final Tile tile;
//   final double progress;
//   final double intensity;

//   const _MergeBurstWidget({
//     required this.tile,
//     required this.progress,
//     required this.intensity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final ringScale = 0.7 + (progress * (1.0 + 0.4 * intensity));
//     final ringOpacity = (1 - progress).clamp(0.0, 1.0);
//     final sparkleOffset = 8.0 + (progress * (12.0 + 5 * intensity));
//     final sparkleOpacity = (1 - progress * 1.2).clamp(0.0, 1.0);
//     final sparkleSize = 11.0 + intensity * 2.0;
//     final ringStroke = 3.0 + intensity;

//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Center(
//           child: Transform.scale(
//             scale: ringScale,
//             child: Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: tile.color.withValues(alpha: 0.8 * ringOpacity),
//                   width: ringStroke,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: tile.color.withValues(
//                       alpha: (0.28 + intensity * 0.08) * ringOpacity,
//                     ),
//                     blurRadius: 16 + intensity * 8,
//                     spreadRadius: 1 + intensity * 1.5,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         ...[
//           const Offset(1, 0),
//           const Offset(-1, 0),
//           const Offset(0, 1),
//           const Offset(0, -1),
//           const Offset(0.7, 0.7),
//           const Offset(-0.7, 0.7),
//         ].map((dir) {
//           return Center(
//             child: Transform.translate(
//               offset: Offset(dir.dx * sparkleOffset, dir.dy * sparkleOffset),
//               child: Opacity(
//                 opacity: sparkleOpacity,
//                 child: Text('✨', style: TextStyle(fontSize: sparkleSize)),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

// class _FloatingScoreWidget extends StatelessWidget {
//   final int points;
//   final int level;
//   final double progress;

//   const _FloatingScoreWidget({
//     required this.points,
//     required this.level,
//     required this.progress,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final travelY = 6 + 30 * progress;
//     final opacity = (1 - progress).clamp(0.0, 1.0);
//     final scale = 0.92 + ((1 - (progress - 0.15).abs()).clamp(0.0, 1.0) * 0.12);
//     final fontSize = (14 + min(level, 8)).toDouble();

//     return Transform.translate(
//       offset: Offset(0, -travelY),
//       child: Opacity(
//         opacity: opacity,
//         child: Transform.scale(
//           scale: scale,
//           child: Text(
//             '+$points',
//             style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: Colors.amber.shade700,
//               shadows: const [
//                 Shadow(
//                   color: Colors.black26,
//                   blurRadius: 3,
//                   offset: Offset(0, 1),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TileWidget extends StatelessWidget {
//   final Tile? tile;

//   const TileWidget({super.key, required this.tile});

//   @override
//   Widget build(BuildContext context) {
//     if (tile == null) {
//       return Container(
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(255, 255, 255, 0.02),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
//         ),
//       );
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: tile!.color,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: tile!.color.withValues(alpha: 0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(tile!.emoji, style: const TextStyle(fontSize: 28)),
//           const SizedBox(height: 4),
//           Text(
//             'Lv${tile!.level}',
//             style: const TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Tile {
//   final int level;
//   final String emoji;
//   final Color color;

//   Tile({required this.level, required this.emoji, required this.color});

//   static const List<String> emojis = [
//     '🍎',
//     '🍊',
//     '🍋',
//     '🍌',
//     '🍇',
//     '🍓',
//     '🍒',
//     '🍑',
//   ];
//   static const List<Color> colors = [
//     Color(0xFFE63946),
//     Color(0xFFF77F00),
//     Color(0xFFEAE2B7),
//     Color(0xFFFDD835),
//     Color(0xFF7C3AED),
//     Color(0xFFEC4899),
//     Color(0xFF00BCD4),
//     Color(0xFF4CAF50),
//   ];

//   Tile merge() {
//     if (level >= 8) {
//       return Tile(level: 8, emoji: emojis[7], color: colors[7]);
//     }
//     final newLevel = level + 1;
//     return Tile(
//       level: newLevel,
//       emoji: emojis[newLevel - 1],
//       color: colors[newLevel - 1],
//     );
//   }
// }

// class GameBoard {
//   final int rows;
//   final int cols;
//   late List<List<Tile?>> board;
//   List<DisappearingTile> disappearingTiles = [];
//   List<MergingTile> mergingTiles = [];
//   List<MergeBurstEffect> mergeBurstEffects = [];
//   List<FloatingScoreEffect> floatingScoreEffects = [];
//   final TickerProvider vsync;
//   VoidCallback? onVisualStateChanged;
//   void Function(MergeEvent event)? onMergeTriggered;

//   GameBoard(this.rows, this.cols, this.vsync) {
//     board = List.generate(rows, (_) => List.filled(cols, null));
//   }

//   void initialize() {
//     for (int i = 0; i < rows; i++) {
//       for (int j = 0; j < cols; j++) {
//         board[i][j] = null;
//       }
//     }
//   }

//   void clear() {
//     for (int i = 0; i < rows; i++) {
//       for (int j = 0; j < cols; j++) {
//         board[i][j] = null;
//       }
//     }
//     disappearingTiles.clear();
//     mergingTiles.clear();
//     mergeBurstEffects.clear();
//     floatingScoreEffects.clear();
//   }

//   void removeDisappearingTile(DisappearingTile dt) {
//     disappearingTiles.remove(dt);
//     onVisualStateChanged?.call();
//   }

//   void removeMergingTile(MergingTile mt) {
//     mergingTiles.remove(mt);
//     onVisualStateChanged?.call();
//   }

//   void removeMergeBurstEffect(MergeBurstEffect effect) {
//     mergeBurstEffects.remove(effect);
//     onVisualStateChanged?.call();
//   }

//   void removeFloatingScoreEffect(FloatingScoreEffect effect) {
//     floatingScoreEffects.remove(effect);
//     onVisualStateChanged?.call();
//   }

//   void dropTile(Tile tile) {
//     // 랜덤한 열에 과일을 떨어뜨림
//     final col = Random().nextInt(cols);

//     // 위에서부터 아래로 빈 공간을 찾기
//     for (int row = rows - 1; row >= 0; row--) {
//       if (board[row][col] == null) {
//         board[row][col] = tile;
//         return;
//       }
//     }
//   }

//   void dropTileToRow(Tile tile, int startRow, int col) {
//     // 지정된 행과 열에 과일 배치 후 아래로 떨어뜨림
//     if (col < 0 || col >= cols) return;

//     // 지정된 행에 과일 배치
//     board[startRow][col] = tile;

//     // 중력 작용 - 그 열만 아래로 떨어뜨리기
//     for (int row = startRow; row < rows - 1; row++) {
//       if (board[row + 1][col] == null) {
//         board[row + 1][col] = board[row][col];
//         board[row][col] = null;
//       } else {
//         break;
//       }
//     }
//   }

//   int findDropRow(int col) {
//     if (col < 0 || col >= cols) return -1;
//     for (int row = rows - 1; row >= 0; row--) {
//       if (board[row][col] == null) return row;
//     }
//     return -1;
//   }

//   bool isBoardFull() {
//     for (int col = 0; col < cols; col++) {
//       if (findDropRow(col) >= 0) {
//         return false;
//       }
//     }
//     return true;
//   }

//   int handleDroppedTile(Tile tile, int col) {
//     final targetRow = findDropRow(col);
//     if (targetRow < 0) return 0;

//     board[targetRow][col] = tile;
//     return checkAndMerge();
//   }

//   int checkAndMerge() {
//     int points = 0;
//     while (true) {
//       bool mergedThisStep = false;

//       // 1) 세로(아래) 병합 우선 탐색
//       verticalLoop:
//       for (int row = 0; row < rows; row++) {
//         for (int col = 0; col < cols; col++) {
//           final tile = board[row][col];
//           if (tile == null) continue;

//           if (row + 1 < rows &&
//               board[row + 1][col] != null &&
//               board[row + 1][col]!.level == tile.level) {
//             final mergedTile = tile.merge();
//             final disappearingTile = board[row][col]!;
//             final gainedPoints = mergedTile.level * 10;
//             board[row][col] = null;
//             board[row + 1][col] = mergedTile;
//             disappearingTiles.add(
//               DisappearingTile(row, col, disappearingTile, vsync, this),
//             );
//             mergingTiles.add(
//               MergingTile(row + 1, col, mergedTile, vsync, this),
//             );
//             mergeBurstEffects.add(
//               MergeBurstEffect(row + 1, col, mergedTile, vsync, this),
//             );
//             floatingScoreEffects.add(
//               FloatingScoreEffect(
//                 row + 1,
//                 col,
//                 gainedPoints,
//                 mergedTile.level,
//                 vsync,
//                 this,
//               ),
//             );
//             onMergeTriggered?.call(
//               MergeEvent(
//                 row: row + 1,
//                 col: col,
//                 level: mergedTile.level,
//                 points: gainedPoints,
//               ),
//             );
//             points += gainedPoints;
//             mergedThisStep = true;
//             break verticalLoop;
//           }
//         }
//       }

//       // 2) 세로 병합이 없을 때만 가로 병합 탐색
//       if (!mergedThisStep) {
//         horizontalLoop:
//         for (int row = 0; row < rows; row++) {
//           for (int col = 0; col < cols; col++) {
//             final tile = board[row][col];
//             if (tile == null) continue;

//             if (col + 1 < cols &&
//                 board[row][col + 1] != null &&
//                 board[row][col + 1]!.level == tile.level) {
//               final mergedTile = tile.merge();
//               final disappearingTile = board[row][col + 1]!;
//               final gainedPoints = mergedTile.level * 10;
//               board[row][col] = mergedTile;
//               board[row][col + 1] = null;
//               disappearingTiles.add(
//                 DisappearingTile(row, col + 1, disappearingTile, vsync, this),
//               );
//               mergingTiles.add(MergingTile(row, col, mergedTile, vsync, this));
//               mergeBurstEffects.add(
//                 MergeBurstEffect(row, col, mergedTile, vsync, this),
//               );
//               floatingScoreEffects.add(
//                 FloatingScoreEffect(
//                   row,
//                   col,
//                   gainedPoints,
//                   mergedTile.level,
//                   vsync,
//                   this,
//                 ),
//               );
//               onMergeTriggered?.call(
//                 MergeEvent(
//                   row: row,
//                   col: col,
//                   level: mergedTile.level,
//                   points: gainedPoints,
//                 ),
//               );
//               points += gainedPoints;
//               mergedThisStep = true;
//               break horizontalLoop;
//             }
//           }
//         }
//       }

//       if (!mergedThisStep) break;
//       gravity();
//     }

//     return points;
//   }

//   void gravity() {
//     // 중력 작용 - 아래로 떨어지기
//     for (int col = 0; col < cols; col++) {
//       for (int row = rows - 1; row >= 0; row--) {
//         if (board[row][col] == null) {
//           // 위에서 타일 찾기
//           for (int checkRow = row - 1; checkRow >= 0; checkRow--) {
//             if (board[checkRow][col] != null) {
//               board[row][col] = board[checkRow][col];
//               board[checkRow][col] = null;
//               break;
//             }
//           }
//         }
//       }
//     }
//   }

//   Tile? getTile(int row, int col) {
//     if (row < 0 || row >= rows || col < 0 || col >= cols) {
//       return null;
//     }
//     return board[row][col];
//   }

//   void setTile(int row, int col, Tile? tile) {
//     if (row >= 0 && row < rows && col >= 0 && col < cols) {
//       board[row][col] = tile;
//     }
//   }
// }
