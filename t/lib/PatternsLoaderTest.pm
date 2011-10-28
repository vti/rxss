package PatternsLoaderTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;
use Test::Fatal;

use RXSS::PatternsLoader;

sub die_on_unknown_file : Test {
    my $self = shift;

    ok(exception { $self->_build_loader->load('foo') });
}

sub load_patterns : Test {
    my $self = shift;

    my $loader = $self->_build_loader;

    ok($loader->load('t/patterns'));
}

sub return_next_pattern : Test {
    my $self = shift;

    my $loader = $self->_build_loader;

    $loader->load('t/patterns');

    is($loader->next, 'foo');
}

sub return_last_pattern : Test {
    my $self = shift;

    my $loader = $self->_build_loader;

    $loader->load('t/patterns');
    $loader->next;

    is($loader->next, 'bar');
}

sub return_undef_on_eof : Test {
    my $self = shift;

    my $loader = $self->_build_loader;

    $loader->load('t/patterns');

    $loader->next;
    $loader->next;

    ok(not defined $loader->next);
}

sub _build_loader {
    my $self = shift;

    return RXSS::PatternsLoader->new(@_);
}

1;
