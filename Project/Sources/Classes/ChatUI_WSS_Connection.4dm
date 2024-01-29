Class extends Chat_WSS_Connection

Class constructor($connection : cs:C1710._Connection)
	
	Super:C1705($connection)
	
Function onMessage($socket : 4D:C1709.WebSocketConnection; $message : cs:C1710._Message)
	
	Super:C1706.onMessage($socket; $message)
	
	If (Form:C1466#Null:C1517)
		Form:C1466.onMessage($socket; $message)
	End if 
	
Function onOpen($socket : 4D:C1709.WebSocketConnection; $open : cs:C1710._Open)
	
	Super:C1706.onOpen($socket; $open)
	
	If (Form:C1466#Null:C1517)
		Form:C1466.onOpen($socket; $open)
	End if 
	
Function onTerminate($socket : 4D:C1709.WebSocketConnection; $terminate : cs:C1710._Terminate)
	
	Super:C1706.onTerminate($socket; $terminate)
	
	If (Form:C1466#Null:C1517)
		Form:C1466.onTerminate($socket; $terminate)
	End if 