#=============================================================================
#     FileName: plot.pl
#         Desc: A short script for using a maf tab file to draw a aligment block
#               graph.
#       Author: tanhao
#        Email: tanhao2013@gmail.com
#     HomePage: http://buttonwood.github.io
#      Version: 0.0.1
#   LastChange: 2014-04-21 15:31:28
#      History:
#=============================================================================

use Data::Dumper;
use SVG;

die("perl $0 lastz.tab >out.svg \n")unless(@ARGV==1);

open(IN,"<$ARGV[0]");
my %tar;
my %que;
my %hash;

while(<IN>){
	next if (/#/);
	next if (/^$/);
    my @t = split;
    $tar{$t[0]} = $t[5];  #target length
    $que{$t[6]} = $t[11]; #queru length
    push @{$hash{$t[0]}{$t[6]}}, [$t[2],$t[3],$t[8],$t[9],$t[5],$t[11],$t[10]]; #alignments
}
close IN;

#print Dumper(\%hash);
my $width  = 900;
my $height = 500;
my $region = 3.5;

#my $svg= SVG->new(width=>500,height=>400);
my $svg = SVG->new('width', ($width+100), 'height', ($height+100));

my @qv = values %que;
my @tv = values %tar;

my $len1 = &sum(\@qv) + 10000;
my $len2 = &sum(\@tv) + 10000;
my $len  = ($len1 > $len2) ? $len1 : $len2;

my @col_tab = ("deepskyblue","aqua","bisque","blueviolet","gold",
              "green","greenyellow","hkaki","orangered","olive",
              "orange","mediumblue","palegreen","deeppink");

my $block = ($#tv > $#qv) ? $#tv : $#qv ;
my $scale =  (($width + 100) - ( ($block + 5) * $region ))/$len;

my $idx = 0;
my $tmp  = 10;
foreach (sort{$tar{$b} <=> $tar{$a}} (keys %tar)){
    my $y = $tar{$_} * $scale;
    $tar{$_} = [$tmp,$y]; # target location [st, ed]
    my $col = $col_tab[$idx % ($#col_tab + 1)]; $idx++;
    $svg->rect(x => $tmp, y => 200, width => $y, height => 10,
            rx => 2.5, ry => 2.5, style => "fill:$col");
    $tmp += $y + $region;
}

$tmp = 10;
foreach (sort{$que{$b} <=> $que{$a}} (keys %que)){
	my $y = $que{$_} * $scale;
	$que{$_} = [$tmp,$y]; # query location [st, ed]
    my $col = $col_tab[$idx % ($#col_tab + 1)]; $idx++;
    $svg->rect(x => $tmp, y => 350, width => $y, height => 10,
            rx => 2.5, ry => 2.5, style => "fill:$col");
    $tmp += $y + $region;
}

foreach my $t (keys %hash) {
    my $tx = $tar{$t}->[0];
    my $ty = $tar{$t}->[1];
    foreach my $q (keys %{$hash{$t}}) {
        my $qx = $que{$q}->[0];
        my $qy = $que{$q}->[1];
        #my $tg = $hash{$t}{$q};
        #print Dumper($tg);
        foreach my $tg (@{$hash{$t}{$q}}) {
            #print Dumper($tg);
            my $ts = $tg->[0]; # target alignment start
            my $te = $tg->[1]; # target alignment end
            my $qs = $tg->[2]; # query alignment start
            my $qe = $tg->[3]; # query alignment end
            my $tl = $tg->[4]; # target length
            #print $tl,"\n";
            my $ql = $tg->[5]; # query length
            my $sd = $tg->[6]; # alignment strand;
            my $style = "";
            if ($sd eq "+"){
                $style = "stroke:rgb(70,130,180)"; # SteelBlue
            }else{
                $style = "stroke:rgb(255,20,147)"; # pink
            }

            $svg->line(x1 => $tx + ($ts/$tl) * $ty,
                        y1 => 210,
                        x2 => $qx + ($qs/$ql) * $qy,
                        y2 => 350,
                        "stroke-width" => 2,
                        style =>$style
                        );
            $svg->line(x1 => $tx + ($te/$tl) * $ty,
                        y1 => 210,
                        x2 => $qx + ($qe/$ql) * $qy,
                        y2 => 350,
                        "stroke-width" => 2,
                        style =>$style
                        #style =>"stroke:rgb(255,20,147)"
                        );
        }
    }
}


print  $svg->xmlify;

sub sum{
    my $a = shift;
    #print Dumper($a);
    my $s = 0;
    foreach (@$a){
        $s += $_;
    }
    return $s;
}


#les ../lastz.tab |grep -v "#" |awk 'BEGIN{OFS="\t"}{if($11=="+"){print "linkid"NR,$1,$3,$4"color=blue\nlinkid"NR,$7,$9,$10,"color=blue"}else{print "linkid"NR,$1,$3,$4"color=pink\nlinkid"NR,$7,$9,$10,"color=pink"}}'|les >links.txt
# les ../lastz.tab |grep -v "#" |awk 'BEGIN{OFS="\t"}{if($11=="+"){print "linkid"NR,$1,$3,$4"\nlinkid"NR,$7,$9,$10,"color=blue"}else{print "linkid"NR,$1,$3,$4"\nlinkid"NR,$7,$9,$10,"color=pink"}}'|les >links.txt
