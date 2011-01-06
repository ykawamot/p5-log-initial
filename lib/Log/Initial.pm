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
        my $msg = ref $_ ? Dumper $_ : $_;

        $buf .= sprintf(
            "[%s] [%s] %s(%d): %s\n",
            scalar localtime,
            $S, $F, $L, $_,
        ) for (split /\n/, $msg);
    }

    print {$FH} $buf;
}

1;
__END__

=head1 NAME

Log::Initial - very simple logger

=head1 SYNOPSIS

  use Log::Initial;
  
  # usual usage
  I('This is message.');

  # dump array or hash ref
  $array_ref = [qw(aaa bbb)];
  I($array_ref);
  
  $hash_ref = {
    aaa => 'bbb',
    ccc => 'ddd',
  };
  I($hash_ref);

=head1 DESCRIPTION

Log::Initial is very simple logger, but high functionality.

=head2 METHODS

  D( ... ); # debug, no output by default 
  I( ... ); # info
  W( ... ); # warning
  E( ... ); # error
  F( ... ); # fatal, automatically exit(1)

=head2 VARIABLES

=item *

$DEBUG I<[0|1]> (default:0)

Debug message doesn't output by default. 

  D( ... ); # no output

  $Log::Initial::DEBUG = 1;

  D( ... ); # output

=item *

$FH I<*FILEHANDLE> (default:*STDOUT)

Log message output to STDOUT by default.

  use IO::File;
  use Log::Initial;
  
  my $fh = IO::File->new('/path/to.log', 'a');
  $Log::Initial::FH = $fh;
  I( ... );
  $fh->close;

=back

=head1 AUTHOR

Yuji Kawamoto E<lt>yukawamoto at gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
