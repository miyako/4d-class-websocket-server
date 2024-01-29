Class extends _WSS_Connection

property remoteAddress : Text
property url : Text

Class constructor($connection : cs:C1710._Connection)
	
	Super:C1705()
	
	This:C1470.remoteAddress:=$connection.request.remoteAddress
	This:C1470.url:=$connection.request.url
	This:C1470.room:=$connection.request.query.room
	
	This:C1470.ORDA:={}
	This:C1470.ORDA.room:=ds:C1482.Room.select(This:C1470.room)
	This:C1470.ORDA.user:=ds:C1482.User.select(This:C1470.remoteAddress)
	
Function onMessage($socket : 4D:C1709.WebSocketConnection; $message : cs:C1710._Message)
	
	Case of 
		: ($socket.wss.dataType="text")
			
			var $connection : Object
			For each ($connection; $socket.wss.connections.query("id != :1 and handler.room == :2"; $socket.id; $socket.handler.room))
				$connection.send(This:C1470.formatMessage($message.data))
			End for each 
			
	End case 
	
	$socket.handler.instance.stream:=$message
	$socket.handler.instance.connection:=This:C1470
	
	ds:C1482.Post.add(This:C1470.ORDA.room; This:C1470.ORDA.user; $message.data)
	
Function onOpen($socket : 4D:C1709.WebSocketConnection; $open : cs:C1710._Open)
	
	$remoteAddress:=$socket.handler.remoteAddress
	
	$socket.send(This:C1470.formatMessage("こんにちは"+$remoteAddress; True:C214))
	
	var $connection : Object
	For each ($connection; $socket.wss.connections.query("id != :1 and handler.room == :2"; $socket.id; $socket.handler.room))
		$connection.send(This:C1470.formatMessage($remoteAddress+"が入室しました"; True:C214))
	End for each 
	
	$socket.handler.instance.stream:=$open
	$socket.handler.instance.connection:=This:C1470
	
	ds:C1482.Access.add(This:C1470.ORDA.room; This:C1470.ORDA.user; "in")
	
Function onTerminate($socket : 4D:C1709.WebSocketConnection; $terminate : cs:C1710._Terminate)
	
	$remoteAddress:=$socket.handler.remoteAddress
	
	var $connection : Object
	For each ($connection; $socket.wss.connections.query("id != :1"; $socket.id))
		$connection.send(This:C1470.formatMessage($remoteAddress+"が退室しました"; True:C214))
	End for each 
	
	$socket.handler.instance.stream:=$terminate
	$socket.handler.instance.connection:=This:C1470
	
	ds:C1482.Access.add(This:C1470.ORDA.room; This:C1470.ORDA.user; "out")
	
Function onError($socket : 4D:C1709.WebSocketConnection; $error : cs:C1710._Error)
	
	$socket.handler.instance.stream:=$error
	$socket.handler.instance.connection:=This:C1470
	
Function formatMessage($message : Text; $isAdmin : Boolean)
	
	$data:={}
	
	$data.message:=$message
	$data.remoteAddress:=This:C1470.remoteAddress
	$data.isAdmin:=$isAdmin
	$data.backgroundColor:=$isAdmin ? "red" : "green"
	
	return JSON Stringify:C1217($data)