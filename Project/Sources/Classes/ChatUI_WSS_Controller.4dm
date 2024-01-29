Class extends Chat_WSS_Controller

Class constructor()
	
	Super:C1705()
	
Function onError($socket : 4D:C1709.WebSocketServer; $error : cs:C1710._Error)
	
	If (Form:C1466#Null:C1517)
		Form:C1466.info.error:=$error
	End if 
	
Function onTerminate($socket : 4D:C1709.WebSocketServer; $terminate : cs:C1710._Terminate)
	
	$socket.handler.instance.close($socket)
	
	If (Form:C1466#Null:C1517)
		Form:C1466.info.terminate:=$terminate
		Form:C1466.update()
		FORM GOTO PAGE:C247(3)
	End if 
	
Function onConnection($socket : 4D:C1709.WebSocketServer; $connection : cs:C1710._Connection)->$object : Object
	
	$object:=cs:C1710.ChatUI_WSS_Connection.new($connection)
	
	$object.instance:=$socket.handler.instance
	
	return $object