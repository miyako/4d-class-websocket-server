Class extends DataClass

Function select($remoteAddress : Text)->$user : cs:C1710.UserEntity
	
	$user:=This:C1470.query("remoteAddress == :1"; $remoteAddress).first()
	
	If ($user=Null:C1517)
		$user:=This:C1470.new()
		$user.remoteAddress:=$remoteAddress
		$user.save()
	End if 