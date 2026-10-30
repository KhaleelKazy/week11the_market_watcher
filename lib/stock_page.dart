import 'package:flutter/material.dart';
import 'stock_bloc.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late final StockBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = StockBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<Stock>(
        stream: bloc.stockStream,
        initialData: bloc.currentStock,
        builder: (context, snapshot) {
          final stock = snapshot.data ?? bloc.currentStock;

          final priceColor = stock.dailyChange > 0
              ? Colors.green
              : stock.dailyChange < 0
              ? Colors.red
              : Colors.grey;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stock.symbol,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '\$${stock.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: priceColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Daily Change: ${stock.dailyChange >= 0 ? '+' : ''}'
                      '\$${stock.dailyChange.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: priceColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Quantity: ${stock.quantity}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        bloc.inputSink.add(StockAction.buy);
                      },
                      child: const Text('Buy'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        bloc.inputSink.add(StockAction.sell);
                      },
                      child: const Text('Sell'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}