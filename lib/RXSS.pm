package RXSS;

use strict;
use warnings;

use base 'RXSS::Base';

use RXSS::UserAgent;
use RXSS::FormFinder;
use RXSS::PatternsLoader;

sub run {
    my $self = shift;
    my (@urls) = @_;

    foreach my $url (@urls) {
        $self->_process($url);
    }

    return $self;
}

sub _process {
    my $self = shift;
    my ($url) = @_;

    my $patterns_loader = $self->_build_patterns_loader;
    $patterns_loader->load($self->{patterns});

    my $ua = $self->_build_ua;

    my $html = $ua->get($url);

    my $forms =
      $self->_build_form_finder(base_url => $url)->find_forms($html);

    foreach my $form (@$forms) {
        my $action = $form->{action};

        while (defined(my $pattern = $patterns_loader->next)) {
            foreach my $field (@{$form->{fields}}) {
                my $form_data = {$field => $pattern};

                my $content = $ua->post($action, $form_data);

                if ($content =~ m/\Q$pattern\E/ms) {
                    warn "Failed\n";
                    warn "    action:  $action\n";
                    warn "    field:   $field\n";
                    warn "    pattern: $pattern\n";
                }
            }
        }
    }
}

sub _build_form_finder {
    my $self = shift;

    return RXSS::FormFinder->new(@_);
}

sub _build_ua {
    my $self = shift;

    return RXSS::UserAgent->new(@_);
}

sub _build_patterns_loader {
    my $self = shift;

    return RXSS::PatternsLoader->new(@_);
}

1;
