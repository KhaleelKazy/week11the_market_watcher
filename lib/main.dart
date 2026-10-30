
import 'dart:async';
import 'dart:math';

enum StockAction {
  buy,
  sell,
}

class Stock {
  final double price;
  final int quantity;

  Stock({
    required this.price,
    required this.quantity,
  });

  Stock copyWith({
    double? price,
    int? quantity,
  }) {
    return Stock(
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class StockBloc {
  final _actionController = StreamController<StockAction>();

  final _stockController = StreamController<Stock>.broadcast();

  final Random _random = Random();

  Stock _currentStock = Stock(
    price: 150.0,
    quantity: 0,
  );

  late final StreamSubscription<StockAction> _actionSubscription;

  Stream<Stock> get stockStream => _stockController.stream;

  Sink<StockAction> get inputSink => _actionController.sink;

  StockBloc() {
    _actionSubscription = _actionController.stream.listen((action) {
      final fluctuation = _random.nextDouble() * 2.0;

      double newPrice;

      if (action == StockAction.buy) {
        newPrice = _currentStock.price + fluctuation;
      } else {
        newPrice = _currentStock.price - fluctuation;
      }

      int newQuantity = _currentStock.quantity;

      if (action == StockAction.buy) {
        newQuantity++;
      } else if (newQuantity > 0) {
        newQuantity--;
      }

      _currentStock = _currentStock.copyWith(
        price: newPrice,
        quantity: newQuantity,
      );

      _stockController.add(_currentStock);
    });
  }

  Future<void> dispose() async {
    await _actionSubscription.cancel();
    await _actionController.close();
    await _stockController.close();
  }
}

Future<void> main() async {
  final bloc = StockBloc();

  bloc.stockStream.listen((stock) {
    print('Price: ${stock.price.toStringAsFixed(2)}');
    print('Quantity: ${stock.quantity}');
    print('------------------');
  });

  bloc.inputSink.add(StockAction.buy);
  bloc.inputSink.add(StockAction.buy);
  bloc.inputSink.add(StockAction.sell);

  await Future.delayed(const Duration(milliseconds: 100));

  await bloc.dispose();
}
