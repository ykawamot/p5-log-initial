use strict;
use Test::More tests => 8;
use IO::Capture::Stdout;
use IO::Socket;

BEGIN {
    use_ok('Log::Initial');
}

my $DayPat   = qr/(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)/;
my $MonPat   = qr/(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)/;
my $DatePat  = qr/$DayPat $MonPat [ \d]\d/;
my $TimePat  = qr/$DatePat \d{2}:\d{2}:\d{2} \d{4}/;
my $LevelPat = qr/[DIWEF]/;
my $FilePat  = qr/[\w\.\-]+\(\d+\)/;
my $LogPat   = qr/\[$TimePat\] \[$LevelPat\] $FilePat:/;

my $c = IO::Capture::Stdout->new;

# scalar
$c->start;
I('aaa');
$c->stop;
like($c->read, qr/^$LogPat aaa$/, 'scalar');

# scalar contains new line
$c->start;
I("aaa\nbbb");
$c->stop;
like($c->read, qr/^$LogPat aaa
$LogPat bbb$/, 'scalar contains new line');

# two args scalar
$c->start;
I('aaa', 'bbb');
$c->stop;
like($c->read, qr/^$LogPat aaa
$LogPat bbb$/, 'two args scalar');

# array ref
$c->start;
I([qw(aaa bbb)]);
$c->stop;
like($c->read, qr/^$LogPat \[
$LogPat   'aaa',
$LogPat   'bbb'
$LogPat \]$/, 'array ref');

# hash ref
$c->start;
I({aaa=>'bbb', ccc=>'ddd'});
$c->stop;
like($c->read, qr/^$LogPat \{
$LogPat   'aaa' => 'bbb',
$LogPat   'ccc' => 'ddd'
$LogPat \}$/, 'hash ref');

# IO::Socket obj
my $io = IO::Socket->new;
$c->start;
I($io);
$c->stop;
like(
    $c->read,
    qr/^$LogPat bless\( \\\*Symbol::GEN0, 'IO::Socket' \)$/,
    'IO::Socket obj',
);

# combination
$c->start;
I('aaa', [qw(aaa bbb)], {aaa=>'bbb', ccc=>'ddd'});
$c->stop;
like($c->read, qr/^$LogPat aaa
$LogPat \[
$LogPat   'aaa',
$LogPat   'bbb'
$LogPat \]
$LogPat \{
$LogPat   'aaa' => 'bbb',
$LogPat   'ccc' => 'ddd'
$LogPat \}$/, 'combination');
