import 'package:flutter/material.dart';

void main() => runApp(UnitConverterApp());

typedef ConverterFunction =
    String Function(String input, String fromUnit, String toUnit);

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/length': (_) => ConverterPage(
          title: 'Length Converter',
          units: ['Centimeter', 'Meter', 'Kilometer', 'Inch'],
          convert: _convertLength,
        ),
        '/temperature': (_) => ConverterPage(
          title: 'Temperature Converter',
          units: ['Celsius', 'Kelvin', 'Fahrenheit'],
          convert: _convertTemperature,
        ),
        '/mass': (_) => ConverterPage(
          title: 'Mass Converter',
          units: ['Kilogram', 'Gram', 'Pound'],
          convert: _convertMass,
        ),
        '/volume': (_) => ConverterPage(
          title: 'Volume Converter',
          units: ['Cubic Kilometer', 'Cubic Meter', 'Liter'],
          convert: _convertVolume,
        ),
        '/base': (_) => ConverterPage(
          title: 'Number Base Converter',
          units: ['Decimal', 'Binary', 'Hexadecimal'],
          isNumericInput: false,
          convert: _convertBase,
        ),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final items = [
    _NavItem('Length', '/length'),
    _NavItem('Temperature', '/temperature'),
    _NavItem('Mass', '/mass'),
    _NavItem('Volume', '/volume'),
    _NavItem('Base', '/base'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unit Converter')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
          children: items.map((item) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, item.route),
              child: Text(item.label, textAlign: TextAlign.center),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label, route;
  _NavItem(this.label, this.route);
}

class ConverterPage extends StatefulWidget {
  final String title;
  final List<String> units;
  final ConverterFunction convert;
  final bool isNumericInput;

  ConverterPage({
    required this.title,
    required this.units,
    required this.convert,
    this.isNumericInput = true,
  });

  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  String inputValue = '';
  String fromUnit = '';
  String toUnit = '';
  String result = '';

  @override
  void initState() {
    super.initState();
    fromUnit = widget.units[0];
    toUnit = widget.units.length > 1 ? widget.units[1] : widget.units[0];
  }

  void _addInput(String value) {
    // Allow one decimal, one minus at start
    if (value == '.' && inputValue.contains('.')) return;
    if (value == '-' && (inputValue.isNotEmpty || inputValue.contains('-')))
      return;
    setState(() {
      inputValue += value;
      _autoConvert();
    });
  }

  void _backspace() {
    if (inputValue.isNotEmpty) {
      setState(() {
        inputValue = inputValue.substring(0, inputValue.length - 1);
        _autoConvert();
      });
    }
  }

  void _autoConvert() {
    if (inputValue.isEmpty || inputValue == '-') {
      result = '';
      return;
    }
    result = widget.convert(inputValue, fromUnit, toUnit);
  }

  void _swap() {
    if (result.isEmpty || result == 'Invalid') return;
    setState(() {
      final tempUnit = fromUnit;
      fromUnit = toUnit;
      toUnit = tempUnit;
      final tempValue = inputValue;
      inputValue = result;
      result = tempValue;
      _autoConvert();
    });
  }

  Widget _buildKeyboard() {
    Widget buildKey(String label, {VoidCallback? onTap, Color? color}) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Colors.white,
              foregroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: onTap,
            child: label == '⌫'
                ? Icon(Icons.backspace_outlined)
                : Text(label, style: TextStyle(fontSize: 22)),
          ),
        ),
      );
    }

    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1
          Row(
            children: [
              buildKey('7', onTap: () => _addInput('7')),
              buildKey('8', onTap: () => _addInput('8')),
              buildKey('9', onTap: () => _addInput('9')),
            ],
          ),
          // Row 2
          Row(
            children: [
              buildKey('4', onTap: () => _addInput('4')),
              buildKey('5', onTap: () => _addInput('5')),
              buildKey('6', onTap: () => _addInput('6')),
            ],
          ),
          // Row 3
          Row(
            children: [
              buildKey('1', onTap: () => _addInput('1')),
              buildKey('2', onTap: () => _addInput('2')),
              buildKey('3', onTap: () => _addInput('3')),
            ],
          ),
          // Row 4
          Row(
            children: [
              buildKey('.', onTap: () => _addInput('.')),
              buildKey('0', onTap: () => _addInput('0')),
              buildKey('-', onTap: () => _addInput('-')),
            ],
          ),
          // Row 5 (backspace full width)
          Row(
            children: [buildKey('⌫', onTap: _backspace, color: Colors.white)],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        inputValue.isEmpty ? '0' : inputValue,
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: fromUnit,
                            decoration: InputDecoration(labelText: 'From'),
                            items: widget.units
                                .map(
                                  (u) => DropdownMenuItem(
                                    value: u,
                                    child: Text(u),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  fromUnit = val;
                                  _autoConvert();
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.swap_horiz, size: 32),
                          onPressed: _swap,
                          tooltip: 'Swap Units and Values',
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: toUnit,
                            decoration: InputDecoration(labelText: 'To'),
                            items: widget.units
                                .map(
                                  (u) => DropdownMenuItem(
                                    value: u,
                                    child: Text(u),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  toUnit = val;
                                  _autoConvert();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 36),
                    Text(
                      result.isEmpty ? '-' : result,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildKeyboard(),
          ],
        ),
      ),
    );
  }
}

// Conversion logic with error checks:

String _convertLength(String input, String from, String to) {
  final v = double.tryParse(input);
  if (v == null || v < 0) return 'Invalid';
  final m = {
    'Centimeter': v / 100,
    'Meter': v,
    'Kilometer': v * 1000,
    'Inch': v * 0.0254,
  }[from]!;
  final out = {
    'Centimeter': m * 100,
    'Meter': m,
    'Kilometer': m / 1000,
    'Inch': m * 0.0254,
  }[to]!;
  return out.toString();
}

String _convertTemperature(String input, String from, String to) {
  final v = double.tryParse(input);
  if (v == null) return 'Invalid';
  if (from == 'Kelvin' && v < 0) return 'Invalid';
  double c = {
    'Celsius': v,
    'Kelvin': v - 273.15,
    'Fahrenheit': (v - 32) * 5 / 9,
  }[from]!;
  double o = {
    'Celsius': c,
    'Kelvin': c + 273.15,
    'Fahrenheit': c * 9 / 5 + 32,
  }[to]!;
  if (to == 'Kelvin' && o < 0) return 'Invalid';
  return o.toStringAsFixed(2);
}

String _convertMass(String input, String from, String to) {
  final v = double.tryParse(input);
  if (v == null || v < 0) return 'Invalid';
  final kg = {'Kilogram': v, 'Gram': v / 1000, 'Pound': v * 0.453592}[from]!;
  final out = {'Kilogram': kg, 'Gram': kg * 1000, 'Pound': kg / 0.453592}[to]!;
  return out.toStringAsFixed(3);
}

String _convertVolume(String input, String from, String to) {
  final v = double.tryParse(input);
  if (v == null || v < 0) return 'Invalid';
  final m3 = {
    'Cubic Kilometer': v * 1e9,
    'Cubic Meter': v,
    'Liter': v / 1000,
  }[from]!;
  final out = {
    'Cubic Kilometer': m3 / 1e9,
    'Cubic Meter': m3,
    'Liter': m3 * 1000,
  }[to]!;
  return out.toStringAsExponential(3);
}

String _convertBase(String input, String from, String to) {
  try {
    final dec = int.parse(
      input,
      radix: {'Binary': 2, 'Decimal': 10, 'Hexadecimal': 16}[from]!,
    );
    return {
      'Binary': dec.toRadixString(2),
      'Decimal': dec.toString(),
      'Hexadecimal': dec.toRadixString(16).toUpperCase(),
    }[to]!;
  } catch (_) {
    return 'Invalid';
  }
}
