package RXSS::Base;

use strict;
use warnings;

use HTML::TreeBuilder;

sub new {
    my $class = shift;

    my $self = bless {@_}, $class;

    $self->BUILD;

    return $self;
}

sub BUILD {}

1;
