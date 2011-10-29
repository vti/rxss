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

sub _log {
    my $self = shift;
    my ($message) = @_;

    return unless $self->{verbose};

    print $message, "\n";
}

sub _process {
    my $self = shift;
    my ($url) = @_;

    $self->_log("Loading patterns from '$self->{patterns}'");

    my $patterns_loader = $self->_build_patterns_loader;
    $patterns_loader->load($self->{patterns});

    my $ua = $self->_build_ua;

    $self->_log("Fetching '$url'...");
    my $html = $ua->get($url);

    my $forms =
      $self->_build_form_finder(base_url => $url)->find_forms($html);

    $self->_log('Found ' . @$forms . ' form(s)');

    foreach my $form (@$forms) {
        my $action = $form->{action};

        $self->_log("Submitting '$action'...");

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
