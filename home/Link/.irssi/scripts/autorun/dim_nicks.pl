use strict;
use warnings;
no warnings 'redefine';
use constant IN_IRSSI => __PACKAGE__ ne 'main' || $ENV{IRSSI_MOCK};
use Irssi;
use Irssi::TextUI;
use Encode;

our $VERSION = '0.3';
our %IRSSI = (
    authors     => 'Nei',
    contact     => 'Nei @ anti@conference.jabber.teamidiot.de',
    url         => "http://anti.teamidiot.de/",
    name        => 'dim_nicks',
    description => 'Dims nicks that are not in channel anymore.',
    license     => 'GNU GPLv2 or later',
   );


sub setc () {
    $IRSSI{name}
}

sub set ($) {
    setc . '_' . $_[0]
}

my $history_lines = 100;

my (%nick_reg, %chan_reg, %history, %history_st, %lost_nicks, %lost_nicks_backup);

my ($dest, $chanref, $nickref);

sub clear_ref {
    $dest = undef;
    $chanref = undef;
    $nickref = undef;
}

sub msg_line_tag {
    my ($srv, $msg, $nick, $addr, $targ) = @_;
    $chanref = $srv->channel_find($targ);
    $nickref = ref $chanref ? $chanref->nick_find($nick) : undef;
}

sub msg_line_clear {
    clear_ref();
}

my $color_letter = '';
my $color_code;

sub color_to_code {
    my $win = Irssi::active_win;
    my $view = $win->view;
    $win->print_after(undef, MSGLEVEL_NEVER, "%$color_letter ");
    my $lp = $win->last_line_insert;
    $color_code = $lp->get_text(1);
    $color_code =~ s/ $//;
    $view->remove_line($lp);
}

sub setup_changed {
    $history_lines = Irssi::settings_get_int( set 'history_lines' );
    my $new_color = Irssi::settings_get_str( set 'color' );
    if ($new_color ne $color_letter) {
	$color_letter = $new_color;
	color_to_code();
    }
}

sub init_dim_nicks {
    setup_changed();
}

sub prt_text_issue {
    ($dest) = @_;
    clear_ref() unless defined $dest->{target};
    clear_ref() unless $dest->{level} & MSGLEVEL_PUBLIC;
}

sub expire_hist {
    for my $ch (keys %history_st) {
	if (@{$history_st{$ch}} > 2 * $history_lines) {
	    my @del = splice @{$history_st{$ch}}, 0, $history_lines;
	    delete @history{ @del };
	}
    }
}

sub prt_text_ref {
    return unless $nickref;
    my ($win) = @_;
    my $view = $win->view;
    my $line_id = $view->{buffer}{_irssi} .','. $view->{buffer}{cur_line}{_irssi};
    $chan_reg{ $chanref->{_irssi} } = $chanref;
    $nick_reg{ $nickref->{_irssi} } = $nickref;
    if (exists $history{ $line_id }) {
    }
    $history{ $line_id } = [ $win->{_irssi}, $chanref->{_irssi}, $nickref->{_irssi}, $nickref->{nick} ];
    push @{$history_st{ $chanref->{_irssi} }}, $line_id;
    expire_hist();
    my @lost_forever = grep { $view->{buffer}{first_line}{info}{time} > $lost_nicks{ $chanref->{_irssi} }{ $_ } }
	keys %{$lost_nicks{ $chanref->{_irssi} }};
    delete @{$lost_nicks{ $chanref->{_irssi} }}{ @lost_forever };
    delete @{$lost_nicks_backup{ $chanref->{_irssi} }}{ @lost_forever };
    clear_ref();
}

sub win_del {
    my ($win) = @_;
    for my $ch (keys %history_st) {
	@{$history_st{$ch}} = grep { exists $history{ $_ } &&
					 $history{ $_ }[0] != $win->{_irssi} } @{$history_st{$ch}};
    }
    my @del = grep { $history{ $_ }[0] == $win->{_irssi} } keys %history;
    delete @history{ @del };
}

sub _alter_lines {
    my ($chan, $check_lr, $ad) = @_;
    my $win = $chan->window;
    return unless ref $win;
    my $view = $win->view;
    my $count = $history_lines;
    my $buffer_id = $view->{buffer}{_irssi} .',';
    my $lp = $view->{buffer}{cur_line};
    my %check_lr = map { $_ => undef } @$check_lr;
    my $redraw;
    while ($lp && $count) {
	my $line_id = $buffer_id . $lp->{_irssi};
	if (exists $check_lr{ $line_id }) {
	    $lp = _alter_line($buffer_id, $line_id, $win, $view, $lp, $chan->{_irssi}, $ad);
	    $redraw = 1;
	}
    } continue {
	--$count;
	$lp = $lp->prev;
    }
    $view->redraw if $redraw;
}

my $irssi_mumbo = qr/\cD[`-i]|\cD[&-@]./;

sub _alter_line {
    my ($buffer_id, $lrp, $win, $view, $lp, $cid, $ad) = @_;
    my $line_nick = $history{ $lrp }[3];
    my $text = $lp->get_text(1);
    my @nick_reg;
    push @nick_reg, substr $line_nick, 0, $_ for 1 .. length $line_nick;
    my $nick_reg = join '|', map { quotemeta } reverse @nick_reg;
    if ($ad) {
	if (exists $lost_nicks_backup{ $cid }{ $line_nick }) {
	    my ($fres, $bres) = @{$lost_nicks_backup{ $cid }{ $line_nick }};
	    $text =~ s/((?:$irssi_mumbo|\s)*)(?:\Q$color_code\E)?($nick_reg)/$fres$2$bres/;
	}
    }
    else {
	if ($text =~ s/((?:$irssi_mumbo|\s)*)($nick_reg)((?:$irssi_mumbo|\s)*)/$1$color_code$2$3/) {
	    $lost_nicks_backup{ $cid }{ $line_nick } = [ $1, $3 ];
	}
    }
    $win->gui_printtext_after($lp->prev, $lp->{info}{level} | MSGLEVEL_NEVER, "$text\n", $lp->{info}{time});
    my $ll = $win->last_line_insert;
    my $line_id = $buffer_id . $ll->{_irssi};
    if (exists $history{ $line_id }) {
    }
    grep { $_ eq $lrp and $_ = $line_id } @{$history_st{ $cid }};
    $history{ $line_id } = delete $history{ $lrp };
    $view->remove_line($lp);
    $ll;
}

sub nick_add {
    my ($chan, $nick) = @_;
    if (delete $lost_nicks{ $chan->{_irssi} }{ $nick->{nick} }) {
	my @check_lr = grep { $history{ $_ }[1] == $chan->{_irssi} &&
				  $history{ $_ }[2] eq $nick->{nick} } keys %history;
	if (@check_lr) {
	    $nick_reg{ $nick->{_irssi} } = $nick;
	    for my $li (@check_lr) {
		$history{ $li }[2] = $nick->{_irssi};
	    }
	    _alter_lines($chan, \@check_lr, 1);
	}
    }
    delete $lost_nicks_backup{ $chan->{_irssi} }{ $nick->{nick} };
}

sub nick_del {
    my ($chan, $nick) = @_;
    my @check_lr = grep { $history{ $_ }[2] eq $nick->{_irssi} } keys %history;
    for my $li (@check_lr) {
	$history{ $li }[2] = $nick->{nick};
    }
    if (@check_lr) {
	$lost_nicks{ $chan->{_irssi} }{ $nick->{nick} } = time;
	_alter_lines($chan, \@check_lr, 0);
    }
    delete $nick_reg{ $nick->{_irssi} };
}

sub nick_change {
    my ($chan, $nick, $oldnick) = @_;
    nick_add($chan, $nick);
}

sub chan_del {
    my ($chan) = @_;
    if (my $del = delete $history_st{ $chan->{_irssi} }) {
	delete @history{ @$del };
    }
    delete $chan_reg{ $chan->{_irssi} };
    delete $lost_nicks{$chan->{_irssi}};
    delete $lost_nicks_backup{$chan->{_irssi}};
}

Irssi::settings_add_int( setc, set 'history_lines',     $history_lines);
Irssi::signal_add_last({
    'setup changed'    => 'setup_changed',
});
Irssi::signal_add({
    'print text'	      => 'prt_text_issue',
    'gui print text finished' => 'prt_text_ref',
    'nicklist new'	      => 'nick_add',
    'nicklist changed'	      => 'nick_change',
    'nicklist remove'	      => 'nick_del',
    'window destroyed'	      => 'win_del',
    'message public'	      => 'msg_line_tag',
    'message own_public'      => 'msg_line_clear',
    'channel destroyed'	      => 'chan_del',
});

sub dumphist {
    my $win = Irssi::active_win;
    my $view = $win->view;
    my $buffer_id = $view->{buffer}{_irssi} .',';
    for (my $lp = $view->{buffer}{first_line}; $lp; $lp = $lp->next) {
	my $line_id = $buffer_id . $lp->{_irssi};
	if (exists $history{ $line_id }) {
	    my $k = $history{ $line_id };
	    if (exists $chan_reg{ $k->[1] }) {
	    }
	    if (exists $nick_reg{ $k->[2] }) {
	    }
	    if (exists $lost_nicks{ $k->[1] } && exists $lost_nicks{ $k->[1] }{ $k->[2] }) {
	    }
	}
    }
}
Irssi::settings_add_str( setc, set 'color', 'K');

init_dim_nicks();

{ package Irssi::Nick }
