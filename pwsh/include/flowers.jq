# flowers.jq
# https://gist.github.com/weeble/957a3fa0d64659600b20216f84c1181d
# https://bsky.app/profile/did:plc:2jaajua5oxc7tlnp476faysn/post/3lpelr2k6x22n

def k(n):"\u001b[\(n)m";

def draw(r;c):
    reduce .[] as $x (
        [range(r)|[range(c)|{v:" ",n:1,col:k(0)}]];
        .[$x.r][$x.c]=($x|{v,n,col})
    )|
    .[]|
    reduce .[] as $x (
        {s:"",k:0,col:""};
        if .k>0 then
            .k-=1
        else
            {s:(.s+(if $x.col!=.col then $x.col else "" end)+$x.v),k:(($x.n//1)-1),col:$x.col}
        end
    )|
    .s;

def ipick($seq;$i;$r):
    $r-seq[$i].w|
    if .<0 then $seq[$i] else ipick($seq;$i+1;.) end;

def wpick:
    . as$seq|
    ([$seq[].w//1]|add)as$l|
    (input%$l)as$i|
    ipick($seq;0;$i);
def rpick:map({w:1,v:.})|wpick.v;

{"U":[
    #{w:4,r:-1,c:0,s:"U",v:"│"},
    {w:4,r:-1,c:0,s:"U",v:"├"},
    {w:4,r:-1,c:0,s:"U",v:"┤"},
    {w:2,r:0,c:-1,s:"L",v:"╮"},
    {w:2,r:0,c:1,s:"R",v:"╭"},
    {w:1,r:0,c:-1,s:"F",v:"╮",n:1},
    {w:1,r:0,c:1,s:"F",v:"╭",n:1}],
"L":[
    {w:2,r:-1,c:0,s:"U",v:"╰"},
    {w:1,r:0,c:-1,s:"F",v:"─",n:1}],
"R":[
    {w:2,r:-1,c:0,s:"U",v:"╯"},
    {w:1,r:0,c:0,s:"F",v:"─",n:1}],
"F":[
    {w:1,r:0,c:0,s:"X",v:"🌸",n:2},
    {w:1,r:0,c:0,s:"X",v:"🌺",n:2},
    {w:1,r:0,c:0,s:"X",v:"🌼",n:2}]
}as$states|
def g:k([92,92,32,32,32,34,36]|rpick);

def grow($r;$c;$col;$lim):
    [{s:"U"}]|until(.[-1].s=="X";.+[$states[.[-1].s]|wpick])[1:$lim+1]|
    reduce .[]as$x({r:$r,c:$c,p:[]};.p+=[$x+{r:.r,c:.c,$col}]|.r+=$x.r|.c+=$x.c)|.p;

[grow(29;(range(300)|(input%150))+5;g;$frame)[]]|draw(30;160)
