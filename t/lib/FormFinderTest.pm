package FormFinderTest;

use strict;
use warnings;

use base 'Test::Class';

use Test::More;

use RXSS::FormFinder;

sub normalize_action : Test {
    my $self = shift;

    my $finder = $self->_build_finder(base_url => 'http://example.com');

    my $forms = $finder->find_forms(
        '<form action="/hello"><input name="bar" /></form>');

    is_deeply(
        $forms,
        [   {   action => 'http://example.com/hello',
                method => 'GET',
                fields => ['bar']
            }
        ]
    );
}

sub do_not_normalize_action_when_action_is_absolute : Test {
    my $self = shift;

    my $finder = $self->_build_finder(base_url => 'http://example.com');

    my $forms = $finder->find_forms(
        '<form action="http://foo.com/hello"><input name="bar" /></form>');

    is_deeply(
        $forms,
        [   {   action => 'http://foo.com/hello',
                method => 'GET',
                fields => ['bar']
            }
        ]
    );
}

sub preserve_query_string : Test {
    my $self = shift;

    my $finder = $self->_build_finder(base_url => 'http://example.com');

    my $forms = $finder->find_forms(
        '<form action="/hello?foo=bar"><input name="bar" /></form>');

    is_deeply(
        $forms,
        [   {   action => 'http://example.com/hello?foo=bar',
                method => 'GET',
                fields => ['bar']
            }
        ]
    );
}

sub find_multiple_forms_in_html : Test {
    my $self = shift;

    my $finder = $self->_build_finder;

    my $forms = $finder->find_forms(
            '<form action="http://foo.com/hello"><input name="bar" /></form>'
          . '<form action="http://foo.com/hello"><input name="bar" /></form>'
    );

    is_deeply(
        $forms,
        [   {   action => 'http://foo.com/hello',
                method => 'GET',
                fields => ['bar']
            },
            {   action => 'http://foo.com/hello',
                method => 'GET',
                fields => ['bar']
            }
        ]
    );
}

sub return_empty_arrayref_when_no_form_was_found : Test {
    my $self = shift;

    my $finder = $self->_build_finder;

    my $forms = $finder->find_forms('foobar');

    is_deeply($forms, []);
}

sub _build_finder {
    my $self = shift;

    return RXSS::FormFinder->new(@_);
}

1;
