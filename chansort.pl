#
# Copyright (C) 2004 by Peder Stray <peder@ninja.no>
#

use strict;
use Irssi;
use Irssi::Irc;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

# ======[ Script Header ]===============================================

use vars qw{$VERSION %IRSSI};
($VERSION) = '$Revision: 1.1 $' =~ / (\d+\.\d+) /;
%IRSSI = (
          name        => 'chansort',
          authors     => 'Peder Stray',
          contact     => 'peder@ninja.no',
          url         => 'http://ninja.no/irssi/chansort.pl',
          license     => 'GPL',
          description => 'Sort all channel and query windows',
         );

# ======[ Commands ]====================================================

# --------[ CHANSORT ]--------------------------------------------------

# Usage: /CHANSORT
sub cmd_chansort {
    my(@windows);
    my($minwin);

    print Dumper $windows[1];

    for my $win (Irssi::windows()) {
	my $act = $win->{active};
	my $key;

	if ($act->{type} eq 'CHANNEL') {
	    $key = "C".$act->{server}{tag}.' '.substr($act->{visible_name}, 1);
	}
	elsif ($act->{type} eq 'QUERY') {
	    $key = "Q".$act->{server}{tag}.' '.$act->{visible_name};
	}
	else {
	    next;
	}
	if (!defined($minwin) || $minwin > $win->{refnum}) {
	    $minwin = $win->{refnum};
	}
	push @windows, [ $key, $win ];

    }

    for (sort {$a->[0] cmp $b->[0]} @windows) {
	my($key,$win) = @$_;
	my($act) = $win->{active};
    
#	printf("win[%d->%d]: t[%s] [%s] [%s] {%s}\n", 
#	       $win->{refnum},
#	       $minwin,
#	       $act->{type},
#	       $act->{visible_name},
#	       $act->{server}{tag},
#	       $key,
#	      );

	$win->command("window move $minwin");
	$minwin++;
    }
}

# ======[ Setup ]=======================================================

# --------[ Register commands ]-----------------------------------------

Irssi::command_bind('chansort', 'cmd_chansort');

# ======[ END ]=========================================================

# Local Variables:
# header-initial-hide: t
# mode: header-minor
# end:

