import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Arial',
      ),
      home: const VisualElementsScreen(),
    );
  }
}

class VisualElementsScreen extends StatefulWidget {
  const VisualElementsScreen({super.key});

  @override
  State<VisualElementsScreen> createState() => _VisualElementsScreenState();
}

class _VisualElementsScreenState extends State<VisualElementsScreen> {
  int _selectedIconIndex = -1;
  int _touchedBarIndex = -1;
  int _datasetIndex = 0; // 0 = weekly, 1 = monthly

  final List<double> _weeklyData = [8, 10, 14, 15, 13];
  final List<double> _monthlyData = [6, 9, 12, 8, 10, 14, 11, 13, 9, 12, 10, 15];

  List<double> get activeData => _datasetIndex == 0 ? _weeklyData : _monthlyData;
  
  List<String> get activeLabels => _datasetIndex == 0 
    ? ['M', 'T', 'W', 'T', 'F']
    : List.generate(12, (i) => '${i + 1}');

  void _onIconTap(int idx) {
    setState(() {
      _selectedIconIndex = _selectedIconIndex == idx ? -1 : idx;
    });

    final labels = ['Home', 'Settings', 'Favorites', 'Camera'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${labels[idx]} tapped')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icons, Images & Interactive Charts'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ToggleButtons(
              isSelected: [_datasetIndex == 0, _datasetIndex == 1],
              onPressed: (i) => setState(() {
                _datasetIndex = i;
                _touchedBarIndex = -1;
              }),
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.teal,
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text('Weekly')),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text('Monthly')),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('1. Interactive Icons', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (i) {
                    final icons = [Icons.home, Icons.settings, Icons.favorite, Icons.camera_alt];
                    final labels = ['Home', 'Settings', 'Favorites', 'Camera'];
                    final colors = [Colors.teal, Colors.blueGrey, Colors.red, Colors.orange];
                    final isSelected = _selectedIconIndex == i;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkResponse(
                          onTap: () => _onIconTap(i),
                          borderRadius: BorderRadius.circular(30),
                          radius: 28,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? colors[i].withOpacity(0.15) : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icons[i], color: colors[i], size: isSelected ? 36 : 28),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: isSelected ? 13 : 11,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('2. Images', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageCard(
                  'Flutter Icon',
                  const Icon(Icons.flutter_dash, size: 100, color: Colors.blue),
                ),
                _buildImageCard(
                  'Network Image',
                  Image.network(
                    'https://picsum.photos/seed/picsum/200',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 100),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('3. Interactive Chart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 320,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: InteractiveBarChart(
                          data: activeData,
                          labels: activeLabels,
                          touchedIndex: _touchedBarIndex,
                          onBarTapped: (index) {
                            setState(() => _touchedBarIndex = index);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Value: ${activeData[index]}'),
                                duration: const Duration(milliseconds: 800),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dataset: ${_datasetIndex == 0 ? "Weekly" : "Monthly"}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Tap bars to inspect',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String title, Widget imageWidget) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(height: 120, width: 120, child: imageWidget),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}

class InteractiveBarChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final int touchedIndex;
  final Function(int) onBarTapped;

  const InteractiveBarChart({
    super.key,
    required this.data,
    required this.labels,
    required this.touchedIndex,
    required this.onBarTapped,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            final barWidth = constraints.maxWidth / data.length;
            final index = (details.localPosition.dx / barWidth).floor();
            if (index >= 0 && index < data.length) {
              onBarTapped(index);
            }
          },
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: BarChartPainter(
              data: data,
              labels: labels,
              touchedIndex: touchedIndex,
            ),
          ),
        );
      },
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final int touchedIndex;

  BarChartPainter({
    required this.data,
    required this.labels,
    required this.touchedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = data.reduce(math.max) + 5;
    final barWidth = size.width / data.length * 0.6;
    final spacing = size.width / data.length;
    final chartHeight = size.height - 40;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = chartHeight * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      
      // Draw y-axis labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(maxValue * i / 4).toInt()}',
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-25, y - 6));
    }

    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final isTouched = i == touchedIndex;
      final barHeight = (data[i] / maxValue) * chartHeight;
      final x = spacing * i + (spacing - barWidth) / 2;
      final y = chartHeight - barHeight;

      // Background bar
      final bgPaint = Paint()..color = Colors.grey.withOpacity(0.1);
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 0, barWidth, chartHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(bgRect, bgPaint);

      // Main bar
      final barPaint = Paint()
        ..color = isTouched ? Colors.tealAccent : Colors.teal;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, isTouched ? barWidth * 1.2 : barWidth, barHeight),
        const Radius.circular(6),
      );
      canvas.drawRRect(rect, barPaint);

      // Draw value on top of bar if touched
      if (isTouched) {
        final valuePainter = TextPainter(
          text: TextSpan(
            text: data[i].toStringAsFixed(0),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        valuePainter.layout();
        valuePainter.paint(
          canvas,
          Offset(x + barWidth / 2 - valuePainter.width / 2, y - 20),
        );
      }

      // Draw x-axis labels
      final labelPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(
          x + barWidth / 2 - labelPainter.width / 2,
          chartHeight + 10,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant BarChartPainter oldDelegate) {
    return oldDelegate.touchedIndex != touchedIndex ||
        oldDelegate.data != data ||
        oldDelegate.labels != labels;
  }
}