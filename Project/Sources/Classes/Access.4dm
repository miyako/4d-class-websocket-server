Class extends DataClass

Function add($room : cs:C1710.RoomEntity; $user : cs:C1710.UserEntity; $kind : Text)->$access : cs:C1710.AccessEntity
	
	$access:=This:C1470.new()
	//reload()したエンティティはエラーになるのでリレーション属性にエンティティを代入しない
	$access.roomId:=$room.getKey()
	$access.userId:=$user.getKey()
	$access.timestamp:=Timestamp:C1445
	$access.kind:=$kind
	$access.save()