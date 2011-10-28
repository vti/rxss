package RXSS::PatternsLoader;

use strict;
use warnings;

use base 'RXSS::Base';

sub load {
    my $self = shift;
    my ($file) = @_;

    die "File '$file' is not readable" unless -r $file;

    open my $fh, '<', $file or die "Can't open file '$file': $!";

    $self->{current} = 0;
    $self->{patterns} = [<$fh>];

    return $self;
}

sub next {
    my $self = shift;

    return unless $self->{current} < @{$self->{patterns}};

    my $pattern = $self->{patterns}->[$self->{current}];
    chomp $pattern;

    $self->{current}++;

    return $pattern;
}

1;
