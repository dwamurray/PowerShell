Workflow DemoSequence {

write-verbose -message ("{0} starting" -f (Get-Date).TimeofDay)
$a=10 
$b=1

"Variables Pre-Sequence"
"`$a = $a"
"`$b = $b"
"`$c = $c"

    Sequence {
        "{0} sequence 1" -f (Get-Date).TimeOfDay
        $workflow:a++
        $c=1
        start-sleep -seconds 1
    }

    Sequence {
        "{0} sequence 2" -f (Get-Date).TimeofDay
        $workflow:a++
        $workflow:b=100
        $c++
        start-sleep -seconds 1
    }

    Sequence {
        "{0} sequence 3" -f (Get-Date).TimeofDay
        $workflow:a++
        $workflow:b*=2
        $c++
        start-sleep -seconds 1
    }

 "Variables Post-Sequence"
 "`$a = $a"
 "`$b = $b"
 "`$c = $c"
 
write-verbose -Message ("{0} ending" -f (Get-Date).TimeOfDay)

}
