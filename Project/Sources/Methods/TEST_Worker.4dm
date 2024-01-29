//%attributes = {"invisible":true}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	//MARK:ストリーム受信を続けるためにワーカーで実行する
	CALL WORKER:C1389("Chat"; Current method name:C684; {})
	
Else 
	
	$instance:=cs:C1710.Chat.new()
	
End if 