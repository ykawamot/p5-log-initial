package Log::Initial;

use strict;
use warnings;
use Data::Dumper;

require Exporter;

our $VERSION = '0.01';
our @ISA     = qw(Exporter);
our @EXPORT  = qw(D I W E F);

our $DEBUG = 0;
our $FH    = *STDOUT;

sub D { _log(@_) if $DEBUG; }
sub I { _log(@_); }
sub W { _log(@_); }
sub E { _log(@_); }
sub F { _log(@_); exit 1; }

sub _log {
    local $Data::Dumper::Indent   = 1;
    local $Data::Dumper::Sortkeys = 1;
    local $Data::Dumper::Terse    = 1;
    
    my ($F, $L, $S) = (caller 1)[1..3];

    $F =~ s#.*/##;
    $S =~ s#.*::##;

    my $buf = '';

    for (@_) {
        if (ref) {
            $_ = Dumper $_;
        }
        $buf .= sprintf(
            "[%s] [%s] %s(%d): %s\n",
            scalar localtime,
            $S, $F, $L, $_,
        ) for (split /\n/);
    }

    print {$FH} $buf;
}

1;
__END__

=head1 NAME

Log::Initial -

=head1 SYNOPSIS

  use Log::Initial;

=head1 DESCRIPTION

Log::Initial is

=head1 AUTHOR

Yuji Kawamoto E<lt>yukawamoto at gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
