Class extends DataClass

Function select($name : Text)->$room : cs:C1710.RoomEntity
	
	$room:=This:C1470.query("name == :1"; $name).first()
	
	If ($room=Null:C1517)
		$room:=This:C1470.new()
		$room.name:=$name
		$room.save()
	End if 
	
Function next()->$name : Text
	
	$name:=String:C10(Num:C11(This:C1470.all().max("name"))+1)
	
Function recents($room : Text)->$posts : cs:C1710.PostSelection
	
	$timestamp:=Timestamp:C1445
	$today:=Substring:C12($timestamp; 1; 10)
	
	$posts:=This:C1470.query("name == :1 and posts.timestamp == :2"; $room; $today+"@").posts.orderBy("timestamp asc")