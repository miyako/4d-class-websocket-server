Class constructor()
	
Function onConnection($socket : 4D:C1709.WebSocketServer; $connection : cs:C1710._Connection) : cs:C1710._WSS_Connection
	
Function onOpen($socket : 4D:C1709.WebSocketServer; $message : cs:C1710._Message)
	
	$socket.handler.instance.open($socket)
	
Function onError($socket : 4D:C1709.WebSocketServer; $message : cs:C1710._Message)
	
Function onTerminate($socket : 4D:C1709.WebSocketServer; $message : cs:C1710._Message)
	
	$socket.handler.instance.close($socket)