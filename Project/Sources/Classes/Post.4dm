Class extends DataClass

Function add($room : cs:C1710.RoomEntity; $user : cs:C1710.UserEntity; $message : Text)->$post : cs:C1710.PostEntity
	
	$post:=This:C1470.new()
	//reload()したエンティティはエラーになるのでリレーション属性にエンティティを代入しない
	$post.roomId:=$room.getKey()
	$post.userId:=$user.getKey()
	$post.timestamp:=Timestamp:C1445
	$post.message:=$message
	$post.save()
	