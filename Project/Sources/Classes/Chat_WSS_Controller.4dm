Class extends _WSS_Controller

Class constructor()
	
	Super:C1705()
	
Function onConnection($socket : 4D:C1709.WebSocketServer; $connection : cs:C1710._Connection)->$object : Object
	
	$object:=cs:C1710.Chat_WSS_Connection.new($connection)
	
	$object.instance:=$socket.handler.instance
	
	return $object