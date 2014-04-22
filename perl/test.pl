use Data::Dumper;

my $a = [1,2,3,4,5,6];
my $b = [7,9,8,10];
my @c;
my @d;

my $x = [1,2]->[0];
my $y = [2,3]->[1];
print "x:$x\ny:$y\n";
print Dumper($a);
print Dumper($b);

push @c, $a;
push @c, $b;
push @d, [1,2,3];
push @d, [4,5,6];

my @aa = (1,2,3,4);
print length(@aa);
print "*****\n";
print $#aa;
print "+++++\n";
print Dumper(\@c);
print Dumper(\@d);
