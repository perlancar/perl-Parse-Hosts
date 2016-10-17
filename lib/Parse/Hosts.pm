package Parse::Hosts;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(parse_hosts);

our %SPEC;

$SPEC{parse_hosts} = {
    v => 1.1,
    summary => 'Parse /etc/hosts',
    args => {
        content => {
            summary => 'Content of /etc/hosts file',
            description => <<'_',

Optional. Will attempt to read `/etc/hosts` from filesystem if not specified.

_
            schema => 'str*',
            cmdline_src => 'stdin',
        },
    },
    examples => [
    ],
};
sub parse_hosts {
    my %args = @_;

    my $content = $args{content};
    unless (defined $content) {
        open my($fh), "<", "/etc/hosts"
            or return [500, "Can't read /etc/hosts: $!"];
        local $/;
        $content = <$fh>;
    }

    my @res;
    for my $line (split /^/, $content) {
        next unless $line =~ /\S/;
        chomp $line;
        next if $line =~ /^\s*#/;
        my ($ip, @hosts) = split /\s+/, $line;
        push @res, {
            ip => $ip,
            hosts => \@hosts,
        };
    }
    [200, "OK", \@res];
}

1;
# ABSTRACT:

=head1 SYNOPSIS

 use Parse::Hosts qw(parse_hosts);
 my $res = parse_hosts();


=head1 SEE ALSO
