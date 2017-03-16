#!/usr/bin/perl


use Getopt::Std;
my %args;
getopt('lp', \%args);
my $lines = $args{l} || 50;
my $prefix = $args{p} || 'x';

my $idx=0;
my @curblock = ();
my @output = ();

sub getLines {
    my $sep = 0;
    if(scalar(@output) != 0 and scalar(@curblock) != 0) {
        $sep = 1;
    }
    return scalar(@output) + $sep + scalar(@curblock);
}

sub addBlock {
    if(scalar(@curblock) > 0) {
        if(scalar(@output) > 0) {
            push @output, "\n";
        }
        push @output, @curblock;
        @curblock = ();
    }
}
sub flushOutput {
    my $fn = sprintf "%s%02d\n", $prefix, $idx;
    open(my $fh, "> $fn")
        || die "Can't open $fn for writing";
    print $fh join("", @output);
    @output = ();
    $idx++;
}

while(<>) {
    if(/^\s*$/) {
        addBlock();
    } else {
        push @curblock, $_;
    }
    if(getLines() >= $lines) {
        if(scalar(@output) == 0) {
            addBlock();
        }
        flushOutput();
    }
}
addBlock();
flushOutput();

