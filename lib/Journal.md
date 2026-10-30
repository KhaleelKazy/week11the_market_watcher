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
automatically rebuilds.while the impertaive is manually
triggered and the setState() rebuilds when called.