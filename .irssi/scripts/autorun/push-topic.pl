# Based on http://scripts.irssi.org/html/topicsed.pl.html
use strict;
use warnings;

use Irssi;

our %IRSSI = (
    authors     => do { use utf8; "Ævar Arnfjörð Bjarmason" },
    contact     => 'avarab@gmail.com',
    name        => "push-topic",
    description => "Push a string to the front of the topic",
    license     => "public domain",
);


sub push_to_topic {
    my ($str, $server, $winit) = @_;

    $str =~ s/^\s+(.*?)\s+$/$1/;

    unless ($str) {
        Irssi::print("Usage: /push-topic <str>");
        return;
    }
    return if (!$server || !$server->{connected} ||
               !$winit || $winit->{type} ne 'CHANNEL');

    my $topic = $winit->{topic};

    if (length $topic) {
        $server->send_raw("TOPIC $winit->{name} :$str | $topic");
    } else {
        $server->send_raw("TOPIC $winit->{name} :$str");
    }
}

Irssi::command_bind('push-topic', 'push_to_topic');
