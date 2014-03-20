# ChangeLog:
# 2005-06-27 Created
# 2006-02-05 Fixed bug when running from status (etc) window
#
# TODO
# - print dates
# - support grepping from all logfiles (when $witem = undef?)
# - options: --before N --after N

use Irssi;
use strict;

use vars qw($VERSION %IRSSI);

$VERSION = '0.0.1';
%IRSSI = (
	authors => 'Heikki Hokkanen',
	contact => 'hoxu at users.sf.net',
	name => 'greplog',
	description => 'like builtin lastlog, but greps from logfile instead (autolog_path)',
	license => 'GPLv2',
);

sub cmd_greplog {
	my ($data, $server, $witem) = @_;
	my $win = Irssi::active_win();

	return unless (defined($server) and defined($witem) and $witem != "0");

	if (!length($data)) {
		Irssi::print("Usage: greplog <pattern>", MSGLEVEL_CLIENTCRAP);
		return;
	}

	my ($tag, $target) = ($server->{tag}, $witem->{name});
	my $file = Irssi::settings_get_str('autolog_path');
	
	$file =~ s/\$tag/$tag/;
	$file =~ s/\$0/$target/;

	Irssi::print("--- Logfile: $file");

	open(FP, '<', glob($file));

	while (my $line = <FP>) {
		if ($line =~ m/$data/) {
			$line =~ s/\n$//;
			Irssi::print("$line");
		}
	}
	
	close(FP);
}


Irssi::command_bind('greplog', \&cmd_greplog);

