package RXSS::UserAgent;

use strict;
use warnings;

use base 'RXSS::Base';;

use URI;
use HTTP::Tiny;

sub get {
    my $self = shift;
    my ($url) = @_;

    $url = $self->_normalize_url($url);

    my $response = $self->_build_ua->get($url);

    die "Failed!\n" unless $response->{success};

    my $content = $response->{content};

    die 'Empty response' unless length $content;

    return $content;
}

sub post {
    my $self = shift;
    my ($url, $form_data) = @_;

    $url = $self->_normalize_url($url);

    my $response = $self->_build_ua->post_form($url, $form_data);

    die "Failed!\n" unless $response->{success};

    my $content = $response->{content};

    die 'Empty response' unless length $content;

    return $content;
}

sub _normalize_url {
    my $self = shift;
    my ($url) = @_;

    $url = "http://$url" unless $url =~ m{^https?://};
    $url = URI->new($url);

    return $url;
}

sub _build_ua {
    my $self = shift;

    return HTTP::Tiny->new;
}

1;
