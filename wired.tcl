#creating a simulator object
set ns [new Simulator]

#trace file
set tracefile [open wired.tr w]
$ns trace-all $tracefile

#nam
set namfile [open wired.nam w]
$ns namtrace-all $namfile

#nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

#links
$ns duplex-link $n0 $n3 3Mb 2ms DropTail
$ns duplex-link $n1 $n3 3Mb 2ms DropTail
$ns duplex-link $n2 $n3 3Mb 2ms DropTail
$ns duplex-link $n3 $n4 7Mb 5ms DropTail
$ns duplex-link $n4 $n5 4Mb 2ms DropTail
$ns duplex-link $n4 $n6 4Mb 2ms DropTail
$ns duplex-link $n4 $n7 4Mb 2ms DropTail

#agents
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp
$ns attach-agent $n5 $null
$ns connect $udp $null

set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp1
$ns attach-agent $n6 $sink1
$ns connect $tcp1 $sink1

set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n2 $tcp2
$ns attach-agent $n7 $sink2
$ns connect $tcp2 $sink2

#applications
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

set ftp [new Application/FTP]
$ftp attach-agent $tcp1

set telnet [new Application/Telnet]
$telnet attach-agent $tcp2

#starting
$ns at 1.0 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 1.0 "$telnet start"

$ns at 10.0 "finish"

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exit 0
}

puts "Wired network simulation starts....."
$ns run

