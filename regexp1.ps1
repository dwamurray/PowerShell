'abcd', 'Abcd', 'abc1', '123a', '!>@#' |
foreach {
 switch -regex -case ($_){
  "[a-z]{4}" {"[a-z]{4} matched $_"} 
  "\d"    {"\d matched $_"}
  "\d{3}" {"\d{3} matched $_"}
  "\W"    {"\W matched $_"}
  default {"Didn't match $_"}
 }
}
