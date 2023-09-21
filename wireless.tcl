#Example of Wireless networks
#Step 1 initialize variables
#Step 2 - Create a Simulator object
#step 3 - Create Tracing and animation file
#step 4 - topography
#step 5 - GOD - General Operations Director
#step 6 - Create nodes
#Step 7 - Create Channel (Communication PATH)
#step 8 - Position of the nodes (Wireless nodes needs a location)
#step 9 - Any mobility codes (if the nodes are moving)
#step 10 - TCP, UDP Traffic
#run the simulation

set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type WAVELAN DSSS 2.4GHz
set val(mac)            Mac/802_11                 ;# MAC typ
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             6                          ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protcol
set val(x)  500   ;# in metres
set val(y)  500   ;# in metres

#Simulator
set ns [new Simulator]
set tracefile [open wireless.tr w]
$ns trace-all $tracefile
set namfile [open wireless.nam w]
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#General Operations Director
create-god $val(nn)
set channel1 [new $val(chan)]
set channel2 [new $val(chan)]
set channel3 [new $val(chan)]

#configuration
$ns node-config -adhocRouting $val(rp) \
  -llType $val(ll) \
  -macType $val(mac) \
  -ifqType $val(ifq) \
  -ifqLen $val(ifqlen) \
  -antType $val(ant) \
  -propType $val(prop) \
  -phyType $val(netif) \
  -topoInstance $topo \
  -agentTrace ON \
  -macTrace ON \
  -routerTrace ON \
  -movementTrace ON \
  -channel $channel1 

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$n0 random-motion 0
$n1 random-motion 0
$n2 random-motion 0
$n3 random-motion 0
$n4 random-motion 0
$n5 random-motion 0
$n6 random-motion 0
$n7 random-motion 0

$ns initial_node_pos $n0 10
$ns initial_node_pos $n1 20
$ns initial_node_pos $n2 30
$ns initial_node_pos $n3 40
$ns initial_node_pos $n4 50
$ns initial_node_pos $n5 60
$ns initial_node_pos $n6 70
$ns initial_node_pos $n7 80

#initial coordinates 
$n0 set X_ 120.0
$n0 set Y_ 240.0
$n0 set Z_ 0.0

$n1 set X_ 30.0
$n1 set Y_ 70.0
$n1 set Z_ 0.0

$n2 set X_ 400.0
$n2 set Y_ 50.0
$n2 set Z_ 0.0

$n3 set X_ 10.0
$n3 set Y_ 30.0
$n3 set Z_ 0.0

$n4 set X_ 90.0
$n4 set Y_ 70.0
$n4 set Z_ 0.0

$n5 set X_ 70.0
$n5 set Y_ 10.0
$n5 set Z_ 0.0

$n6 set X_ 60.0
$n6 set Y_ 40.0
$n6 set Z_ 0.0

$n7 set X_ 30.0
$n7 set Y_ 80.0
$n7 set Z_ 0.0


#mobility 
$ns at 1.0 "$n6 setdest 260.0 30.0 5.0"
$ns at 1.0 "$n7 setdest 10.0 140.0 5.0"
$ns at 1.0 "$n1 setdest 400.0 40.0 5.0"



#agents
set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp1
$ns attach-agent $n6 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 1.0 "$ftp1 start"

set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp2
$ns attach-agent $n7 $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 1.0 "$ftp2 start"

set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n2 $udp
$ns attach-agent $n3 $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$ns at 1.0 "$cbr start"

$ns at 10.0 "finish"

proc finish {} {
 global ns tracefile namfile
 $ns flush-trace
 close $tracefile
 close $namfile
 exit 0
}

puts "Wireless Simulation Starts"
$ns run
