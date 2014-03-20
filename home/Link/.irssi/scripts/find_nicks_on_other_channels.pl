use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
use Set::Functional ':all';

$VERSION = '0.1';
%IRSSI = (
    authors	=> 'Lamperi',
    contact	=> 'lamperi@lamperi.name',
    name	=> 'Find common channels',
    description	=> 'Shows any nicks that lurk on other channels too',
    license	=> 'Public Domain',
    url		=> 'http://lamperi.name',
);

sub cmd_find_nicks_on_other_channels {
    my ($data, $server, $witem) = @_;

    my $look_all = $data eq "-all";

    if (!$server||!$server->{connected}) {
        $witem->print("Not connected to server");
        return;
    }

    if ($witem->{type} eq 'CHANNEL') {
        my @nicks = grep $_->{nick} ne $server->{nick}, (setify_by { $_->{nick} } $witem->nicks());

        for my $channel(Irssi::channels()) {
            if (($look_all or $channel->{server}->{tag} eq $witem->{server}->{tag}) and
                    ($channel->{server}->{tag} ne $witem->{server}->{tag} or $channel->{name} ne $witem->{name})) {
                my @other_nicks = setify_by { $_->{nick} } ( $channel->nicks() );

                my @intersection = intersection_by { $_->{nick} } \@nicks, \@other_nicks;

		if (@intersection) {
                    $witem->print("On " . $channel->{server}->{tag} . "/" . $channel->{name} . ": " . join(", ", (map { $_->{nick} } @intersection)));
                }
            }
        }
    } else {
        $witem->print("Please run on channel window.");
    }
}

Irssi::command_bind('findcommonchannels', 'cmd_find_nicks_on_other_channels');
