# script to display signal to noise ratio of a channel in the statusbar
# todo:
#  -check if message is ignored and consider it as noise
#   this needs separate signal handlers for each message 
#   considered as signal

use strict;
use Irssi;
use Irssi::TextUI;
use Irssi::Irc;
use 5.6.1;
use IO::File;
use vars qw($VERSION %IRSSI $snrbar %snr);

$VERSION = "0.2";
%IRSSI = (
    authors     => 'Valentin Batz',
    contact	=> 'senneth@irssi.org',
    name        => 'snr',
    description => 'displays a signal to noise ratio in the statusbar',
    url		=> 'http://www.oberkommando.org/~senneth/irssi/scripts/',
    license     => 'GPLv2',
    sbitems	=> 'snr',
    revision    => '$LastChangedRevision: 442 $',
    changed     => '$LastChangedDate: 2006-09-20 19:50:42 +0200 (Mi, 20 Sep 2006) $',
    version     => $VERSION,
);

my %snr;
my $snrbar;

sub noise {
	# "nicklist new", CHANNEL_REC, NICK_REC
	# "nicklist remove", CHANNEL_REC, NICK_REC
	# "nicklist changed", CHANNEL_REC, NICK_REC, char *old_nick
	# "channel mode changed", CHANNEL_REC, char *setby
	# "nick mode changed", CHANNEL_REC, NICK_REC, char *setby, char *mode, char *type
	# "channel topic changed", CHANNEL_REC
	my $channel = shift;
	# don't start counting stuff until channel is synched / won't work with /set channel_sync off
	return unless $channel->{synced};
	if ($channel->{chat_type} eq 'IRC') {
		my ($s,$n) = split( "/", $snr{$channel->{server}->{tag}}{$channel->{name}});
		$n++;
		$snr{$channel->{server}->{tag}}{$channel->{name}} = $s.'/'.$n;
		refresh_sbar();
	}
}

sub signal {
	# "message public",         SERVER_REC, char *msg, char *nick, char *address, char *target
	# "message irc action",     SERVER_REC, char *msg, char *nick, char *address, char *target
	# "message own_public",     SERVER_REC, char *msg, char *target
	# "message irc own_action", SERVER_REC, char *msg, char *target
	my ($server, $msg, $nick, $addr, $target) = @_;
	$target = $nick if (!defined($target) && !defined($addr));
	my $channel = $server->channel_find($target);
	return unless defined $channel;
	if ($channel->{chat_type} eq 'IRC') {
		my ($s,$n) = split( "/", $snr{$channel->{server}->{tag}}{$channel->{name}});
		$s++;
		$snr{$channel->{server}->{tag}}{$channel->{name}} = $s.'/'.$n;
		refresh_sbar();
	}
}

sub add_channel {
	my $channel = shift;
	return if defined($snr{$channel->{server}->{tag}}{$channel->{name}});
	if ($channel->{chat_type} eq 'IRC') {
		$snr{$channel->{server}->{tag}}{$channel->{name}} = "0/0";
	}
}

sub init {
	foreach my $channel (Irssi::channels()) {
		if ($channel->{chat_type} eq 'IRC' && !defined($snr{$channel->{server}->{tag}}{$channel->{name}})) {
			$snr{$channel->{server}->{tag}}{$channel->{name}} = "0/0";
		}
	}
}

sub refresh_sbar() {
	my $witem = Irssi::active_win()->{active};
	return unless defined $witem && $witem->{type} eq 'CHANNEL';
	my $server = $witem->{server};
	$snrbar = $snr{$server->{tag}}{$witem->{name}};
	my ($s,$n) = split( "/", $snrbar);
	my $snrcolor = '';
	my $ratio = 0;
	if ($n > 0 && $s > 0) {
	    $ratio = $s / ($s + $n);
            if ($ratio > 0.6) {
              $snrcolor = '%g';
            }
            elsif ($ratio > 0.3) {
              $snrcolor = '%y';
            }
            else {
              $snrcolor = '%r';
            }
	}
	my $snrpercent = sprintf("%.2f%%", $ratio * 100);
	my $snrtmpstr = "%Ksnr%n%W:%n$snrcolor $snrbar($snrpercent)%B";
	$snrbar = $snrtmpstr;
        Irssi::statusbar_items_redraw('snr');
}
        
sub refresh_sbar_later() {
	Irssi::timeout_add_once(1000, \&refresh_sbar, undef);
}
                
sub sb_snr {
        my ($item, $get_size_only) = @_;
	$item->default_handler($get_size_only, "{sb $snrbar}", "", 1);
}

sub cmd_save {
        my $filename = Irssi::get_irssi_dir()."/snr";
        my $io = new IO::File $filename, "w";
        if (defined $io) {
                my $dumper = Data::Dumper->new([\%snr]);
                $dumper->Purity(1)->Deepcopy(1);
                $io->print($dumper->Dump);
                $io->close;
        }
        Irssi::print("snr saved to ".$filename);
}


sub UNLOAD {
	cmd_save();
}

sub cmd_load {
    my $filename = Irssi::get_irssi_dir()."/snr";;
    my $io = new IO::File $filename, "r";
    if (defined $io) {
        no strict 'vars';
        my $text;
        $text .= $_ foreach ($io->getlines);
        my $stats = eval "$text";
        %snr = %$stats if ref $stats;
    }
    Irssi::print("snr loaded from ".$filename);
}

sub say_snr {
  my ($data,$server,$item) = @_;
  return unless ref $item;
  if ($item->{'type'} eq 'CHANNEL') {
 	my $channel = $server->channel_find($item->{'name'});
        return unless defined $channel;
        if ($channel->{chat_type} eq 'IRC') {
           my ($s,$n) = split('/', $snr{$channel->{server}->{tag}}{$channel->{name}});
           return if (($s + $n) == 0);
           my $str = sprintf("%d/%d(%.2f%)", $s, $n, ($s/($s + $n))*100);
	   $channel->command('say '.$str);
        }
  }
}

Irssi::statusbar_item_register('snr', undef, 'sb_snr');
Irssi::statusbars_recreate_items();

Irssi::signal_add("nicklist new",\&noise);
Irssi::signal_add("nicklist changed", \&noise);
Irssi::signal_add("nicklist remove", \&noise);
Irssi::signal_add("channel mode changed", \&noise);
Irssi::signal_add("nick mode changed", \&noise);
Irssi::signal_add("message public", \&signal);
Irssi::signal_add("message own_public", \&signal);
Irssi::signal_add("message irc action", \&signal);
Irssi::signal_add("message irc own_action", \&signal);
Irssi::signal_add("channel created", \&add_channel);
Irssi::signal_add("channel topic changed", \&noise);
Irssi::signal_add('setup saved', 'cmd_save');

Irssi::signal_add('window changed', \&refresh_sbar_later);
Irssi::signal_add('window item changed', \&refresh_sbar_later);
Irssi::signal_add('window item server changed', \&refresh_sbar_later);
Irssi::command_bind('snr', \&say_snr);
cmd_load();
init();
