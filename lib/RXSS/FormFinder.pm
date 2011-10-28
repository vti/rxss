package RXSS::FormFinder;

use strict;
use warnings;

use base 'RXSS::Base';

use HTML::TreeBuilder;

sub find_forms {
    my $self = shift;
    my ($html) = @_;

    my $forms = [];

    my $tree = HTML::TreeBuilder->new_from_content($html);

    foreach my $form ($tree->look_down('_tag', 'form')) {
        my $method = $form->attr('method') || 'GET';
        my $action = $form->attr('action');

        $action = $self->_normalize_action($action);

        my @fields =
          grep { !$_->attr('type') || $_->attr('type') ne 'submit' }
          $form->look_down('_tag', 'input');
        push @fields, $form->look_down('_tag', 'select');

        push @$forms,
          { action => $action,
            method => $method,
            fields => [map { $_->attr('name') } @fields]
          };
    }

    $tree->delete;

    return $forms;
}

sub _normalize_action {
    my $self = shift;
    my ($action) = @_;

    if ($action =~ m{^https?://}) {
        return $action;
    }

    my $base_url = $self->{base_url};
    die 'base_url is required' unless $base_url;

    if ($action =~ m{^/}) {
        $action =~ s{^/}{} if $base_url =~ m{$/};
        return "$base_url$action";
    }

    die 'TODO';
}

1;
