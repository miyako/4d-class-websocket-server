property socket : 4D:C1709.WebSocketServer
property controller : cs:C1710._WSS_Controller

Class constructor($path; $controller : 4D:C1709.Class)
	
	//管理用オブジェクト
	var __WebSocketServer__ : Object
	
	If (__WebSocketServer__=Null:C1517)
		__WebSocketServer__:={}
	End if 
	
	If ($controller#Null:C1517)
		
		var $server : 4D:C1709.WebServer
		
		$server:=WEB Server:C1674
		
		If ($server.isRunning) || ($server.start().success)
			
			If (OB Instance of:C1731($controller; OB Class:C1730(cs:C1710._WSS_Controller)))
				
				$semaphore:=This:C1470.semaphore($path)
				
				//MARK:同じpathでハンドラーを作成すると重複エラー-10718
				If (Not:C34(Test semaphore:C652($semaphore)))
					
					This:C1470.controller:=$controller.new()
					
					//MARK:再起的な参照によりオブジェクトを延命する
					This:C1470.controller.instance:=This:C1470
					
					var $socket : 4D:C1709.WebSocketServer
					
					$socket:=4D:C1709.WebSocketServer.new(This:C1470.controller; {path: $path})
					
					If ($socket#Null:C1517)
						
						This:C1470.socket:=$socket
						
					End if 
					
				End if 
				
			End if 
			
		End if 
		
	End if 
	
Function isRunning($path : Text)
	
	var $semaphore : Text
	$semaphore:=This:C1470.semaphore($path)
	
	return Test semaphore:C652($semaphore)
	
Function requestTerminate($path : Text)
	
	//ハンドラーのアンインストールは非同期処理
	
	var $workers : Collection
	
	$workers:=Get process activity:C1495(Processes only:K5:35).processes.query("type in :1"; [Main process:K36:10; Worker process:K36:32])
	
	var $signal : 4D:C1709.Signal
	
	For each ($worker; $workers)
		CALL WORKER:C1389($worker.name; This:C1470._abort; This:C1470.semaphore; $path)
	End for each 
	
Function _abort($function : 4D:C1709.Function; $path : Text)
	
	var $semaphore : Text
	$semaphore:=$function.call(Null:C1517; $path)
	
	If (Test semaphore:C652($semaphore))
		
		var $socket : 4D:C1709.WebSocketServer
		$socket:=__WebSocketServer__[$path]
		
		If ($socket#Null:C1517)
			$socket.terminate()  //つぎのイベントサイクルでonTerminate()が実行される
		End if 
		
	End if 
	
Function close($socket : 4D:C1709.WebSocketServer)
	
	//MARK:重複エラー-10718を回避するためのsemaphoreをクリア
	$semaphore:=This:C1470.semaphore($socket.path)
	
	If (Test semaphore:C652($semaphore))
		CLEAR SEMAPHORE:C144($semaphore)
	End if 
	
	OB REMOVE:C1226(__WebSocketServer__; $socket.path)
	
Function open($socket : 4D:C1709.WebSocketServer)->$semahore : Boolean
	
	//MARK:重複エラー-10718を回避するためのsemaphoreをセット
	$semahore:=Semaphore:C143(This:C1470.semaphore($socket.path))
	
	var __WebSocketServer__ : Object
	If (__WebSocketServer__=Null:C1517)
		__WebSocketServer__:={}
	End if 
	
	__WebSocketServer__[$socket.path]:=$socket
	
Function semaphore($path : Text)->$semaphore : Text
	
	$semaphore:="$WebSocketServer"+$path
	
Function terminate()
	
	var $socket : 4D:C1709.WebSocketServer
	
	$socket:=This:C1470.socket
	
	If ($socket#Null:C1517)
		//MARK:クライアント接続を切断する
		If (Not:C34($socket.terminated))
			$socket.terminate()
		End if 
	End if 
	
	return This:C1470