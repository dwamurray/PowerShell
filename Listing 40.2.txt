<?php
setcookie('test1','value1');
setcookie('test2','value2');
foreach ($_COOKIE as $key=>$value) {
   echo "You sent cookie '$key' containing '$value' <br>\n";
}
foreach ($_POST as $key=>$value) {
   echo "You sent field '$key' containing '$value' <br>\n";
}
?>
<h1>Enter Details</h1>
<form name="testform" action="cookietest.php" method="post">
<input type="text" name="field1">
<input type="text" name="field2">
</form>
