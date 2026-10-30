import 'dart:async';
import 'dart:math';

enum StockAction {
  bullMarket,
  bearMarket,
  reset,
}

class Stock {
  final String symbol;
  final double price;
  final double dailyChange;
  final int quantity;

  Stock({
    required this.symbol,
    required this.price,
    required this.dailyChange,
    required this.quantity,
  });

  Stock copyWith({
    String? symbol,
    double? price,
    double? dailyChange,
    int? quantity,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      dailyChange: dailyChange ?? this.dailyChange,
      quantity: quantity ?? this.quantity,
    );
  }
}

class StockBloc {
  final _actionController = StreamController<StockAction>();

  final _stockController = StreamController<Stock>.broadcast();

  final Random _random = Random();

  final Stock _initialStock = Stock(
    symbol: 'AAPL',
    price: 150.0,
    dailyChange: 0.0,
    quantity: 0,
  );

  late Stock _currentStock;

  late final StreamSubscription<StockAction> _subscription;

  StockBloc() {
    _currentStock = _initialStock;

    _subscription = _actionController.stream.listen((action) {
      double newPrice = _currentStock.price;

      if (action == StockAction.bullMarket) {
        newPrice += _random.nextDouble() * 2.0;
      } else if (action == StockAction.bearMarket) {
        newPrice -= _random.nextDouble() * 2.0;
      } else if (action == StockAction.reset) {
        _currentStock = _initialStock;
        _stockController.add(_currentStock);
        return;
      }

      final dailyChange = newPrice - _currentStock.price;

      _currentStock = _currentStock.copyWith(
        price: newPrice,
        dailyChange: dailyChange,
      );

      _stockController.add(_currentStock);
    });
  }

  Stream<Stock> get stockStream => _stockController.stream;

  Sink<StockAction> get inputSink => _actionController.sink;

  Stock get currentStock => _currentStock;

  Future<void> dispose() async {
    await _subscription.cancel();
    await _actionController.close();
    await _stockController.close();
  }
}