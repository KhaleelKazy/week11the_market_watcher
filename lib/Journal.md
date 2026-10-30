Journal 1

The difference between mutating a field and using  copywith
method is mutating changes an existing object
while copywith creates a new object and an original
object stays unchanged and make states changes easier
to track compared to mutating.

Journal2

The SteamBuilder know when to rebuild the UI by listening
to StockBloc and receives new data. SteamBuilder is 
reactive because it listens for stream updates and 
automatically rebuilds.while the imperative is manually
triggered and the setState() rebuilds when called.

Journal3

You press the button. Bloc receives action, copyWith() updates
the stock,Bloc sends the update,Streambuilder receives the new
stock, the screen rebuilds. The rebuild happens at 
builder:(context,snapshot)