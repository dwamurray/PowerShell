$F = get-content auth.log |
select-string "Failed password for (.)*\.(.)*\.(.)*\...." |
select -expand matches |
select -expand value


$F = $F.split(" ")
$F[3,5] -join ", "
