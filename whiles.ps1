$i = 0
Do {                                 #A
  $i
  $i++
} While ($i -lt 10)
$i = 0
Do {                                 #B 
  $i
  $i++
} Until ($i -eq 10)
$i = 0                     
                                     #C
While ($i -lt 10) {
  $i
  $i++
}
#A Do-While loop
#B Do-Until loop
#C While loop
