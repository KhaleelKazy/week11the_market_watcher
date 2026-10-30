import 'dart:async';
import 'dart:math';

enum StockAction {
  buy,
  sell,
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

  Stock _currentStock = Stock(
    symbol: 'AAPL',
    price: 150.0,
    dailyChange: 0.0,
    quantity: 0,
  );

  late final StreamSubscription<StockAction> _subscription;

  Stream<Stock> get stockStream => _stockController.stream;

  Sink<StockAction> get inputSink => _actionController.sink;

  Stock get currentStock => _currentStock;

  StockBloc() {
    _subscription = _actionController.stream.listen((action) {
      final fluctuation = _random.nextDouble() * 2.0;

      double newPrice = _currentStock.price;
      int newQuantity = _currentStock.quantity;

      if (action == StockAction.buy) {
        newPrice += fluctuation;
        newQuantity++;
      } else {
        newPrice -= fluctuation;

        if (newQuantity > 0) {
          newQuantity--;
        }
      }

      final dailyChange = newPrice - _currentStock.price;

      _currentStock = _currentStock.copyWith(
        price: newPrice,
        dailyChange: dailyChange,
        quantity: newQuantity,
      );

      _stockController.add(_currentStock);
    });
  }

  Future<void> dispose() async {
    await _subscription.cancel();
    await _actionController.close();
    await _stockController.close();
  }
}