use GD::Graph::bars;
my $graph = GD::Graph::bars->new(400, 300);

my @data = (
    [ "1st", "2nd", "3rd", "4th" ],
    [ 1, 2, 3, 4],
    [ 5, 3, 1, 0]
);

$graph->set(
    x_label           => 'X Label',
    y_label           => 'Y label',
    title             => 'Some simple graph',
    y_max_value       => 6,
    y_tick_number     => 6,
    y_label_skip      => 2
) or die $graph->error;

open(IMG, '>file.png') or die $!;
binmode IMG;
print IMG $graph->plot(\@data)->png;
close IMG;
