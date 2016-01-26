# nickbar.pl for irssi
# Copyright (c) 2005, 2008 Heikki Hokkanen <hoxu at users.sf.net>
#
use Irssi 20021117; # 0.8.6
use vars qw($VERSION %IRSSI);
$VERSION = "0.0.2";
%IRSSI = (
	authors => 'Heikki Hokkanen',
	contact => 'hoxu at users.sf.net',
	name => 'nickbar',
	description => 'Statusbar item for channel nicklist',
	license => 'GPLv2',
	sbitems => 'nickbar',
);

use Irssi::TextUI;
use strict;

# TODO 
# - nickbar_autohide?
# - nickbar_show_modechar
# - nickbar_sortbymode
# - sort: ignore case, highest first

# -----[ Functions ]------------------------------------------------------------

sub redraw_nickbar {
	my ($item, $get_size_only) = @_;
	
	if (Irssi::active_win()->{active}{type} ne "CHANNEL") {
		$item->default_handler($get_size_only, undef, undef, 1);
		# TODO hide?
		return;
	}

	my ($ops, $voices, $halfops);
	my $text;
	my @shownames;

	my @nicks = Irssi::Channel::nicks(Irssi::active_win()->{active});
	my $my_nickname = Irssi::active_win()->{active_server}->{nick}; #$item->{active_server}->{nick};
	my $maxnicks = Irssi::settings_get_int('nickbar_max_nicks');
	my @omit_nicks = split(/ +/, Irssi::settings_get_str('nickbar_omit_nicks'));

	# this actually goes through all the nicks, even if maxnicks is much
	# lower... could optimize
	NICK: foreach my $nick (@nicks) {
		my $tmp;
		my $modechar = "";
		if ($nick->{op}) {
			$modechar = "@";
			$ops++;
		} elsif ($nick->{halfop}) {
			$modechar = "%";
			$halfops++;
		} elsif ($nick->{voice}) {
			$modechar = "+";
			$voices++;
		}

		# don't list own nick
		next if ($nick->{nick} eq $my_nickname);

		# check nicks to omit
		foreach my $omit (@omit_nicks) {
			if ($nick->{nick} eq $omit) { next NICK; }
		}
		$tmp = $modechar . $nick->{nick};
		push(@shownames, $tmp);
	}

	if (Irssi::settings_get_bool('nickbar_summary')) {
		if ($ops) { $text .= "$ops@/"; }
		if ($halfops) { $text .= $halfops ."%/"; }
		if ($voices) { $text .= $voices ."+/"; }
		$text .= (scalar(@nicks)) . " ";
	}
	$text .= join(' ', splice(@{[sort(@shownames)]},0,$maxnicks));

	# show '...' if some nicks are not listed
	if (scalar(@shownames) > $maxnicks) {
		$text .= '...';
	}

	$item->default_handler($get_size_only, undef, $text, 1);
}

sub refresh_nickbar {
	Irssi::statusbar_items_redraw('nickbar');
}

# -----[ Signal hooks ]---------------------------------------------------------

Irssi::signal_add('nicklist changed', \&refresh_nickbar);
Irssi::signal_add('window changed', \&refresh_nickbar);

# -----[ Settings ]-------------------------------------------------------------

Irssi::settings_add_bool('nickbar', 'nickbar_summary', 1);
Irssi::settings_add_int('nickbar', 'nickbar_max_nicks', 10);
Irssi::settings_add_str('nickbar', 'nickbar_omit_nicks', 'ChanServ Q L');

# -----[ Setup ]----------------------------------------------------------------

Irssi::statusbar_item_register('nickbar', '{sb $0-}', 'redraw_nickbar'); # name, value, func
Irssi::statusbars_recreate_items(); # ?

Irssi::print("$IRSSI{name} loaded. Remember to type /statusbar window add nickbar");

