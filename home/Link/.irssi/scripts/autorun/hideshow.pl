use strict;
use warnings;
no warnings 'redefine';
use constant IN_IRSSI => __PACKAGE__ ne 'main' || $ENV{IRSSI_MOCK};
use Irssi;
use Irssi::TextUI;
use Encode;

our $VERSION = '0.2';
our %IRSSI = (
    authors     => 'Nei',
    contact     => 'Nei @ anti@conference.jabber.teamidiot.de',
    url         => "http://anti.teamidiot.de/",
    name        => 'hideshow',
    description => 'Removes and re-adds lines to the Irssi buffer view.',
    license     => 'GNU GPLv2 or later',
   );


sub setc () {
    $IRSSI{name}
}

sub set ($) {
    setc . '_' . $_[0]
}

my (%hidden);

my $dest;

my $HIDE;
my $hide_level;
my $ext_hidden_level = MSGLEVEL_LASTLOG << 1;


sub show_lines {
    for my $win (Irssi::windows) {
	my $view = $win->view;
	my $wid = $win->{_irssi};
	next unless exists $hidden{$wid};
	my $redraw;
	for (my $lp = $view->{buffer}{cur_line}; $lp; $lp = $lp->prev) {
	    my $nl = delete $hidden{$wid}{ $lp->{_irssi} };
	    if ($nl) {
		my $ll = $lp;
		for my $i (@$nl) {
		    $win->gui_printtext_after($ll, $i->[1] | MSGLEVEL_NEVER, "${$i}[0]\n", $i->[2]);
		    $ll = $win->last_line_insert;
		    $redraw = 1;
		}
	    }
	}
	$view->redraw if $redraw;
	delete $hidden{$wid};
    }
    %hidden=();
}

sub hide_lines {
    for my $win (Irssi::windows) {
	my $wid = $win->{_irssi};
	my $view = $win->view;
	my $redraw;
	my $prev;
	my $lid;
	for (my $lp = $view->{buffer}{cur_line}; $lp; $lp = $prev) {
	    $prev = $lp->prev;
	    if ($prev && $lp->{info}{level} & ($hide_level | $ext_hidden_level)) {
		push @{ $hidden{ $wid }
			    { $prev->{_irssi} }
			}, [ $lp->get_text(1), $lp->{info}{level}, $lp->{info}{time} ],
			    @{ (delete $hidden{$wid}{ $lp->{_irssi } }) // [] };
		$view->remove_line($lp);
		$redraw = 1;
	    }
	}
	$view->redraw if $redraw;
    }
}

sub hideshow {
    show_lines();
    if ($HIDE) {
	hide_lines();
    }
}

sub setup_changed {
    my $old_level = $hide_level;
    $hide_level = Irssi::settings_get_level( set 'level' );
    my $old_hidden = $HIDE;
    $HIDE = Irssi::settings_get_bool( set 'hide' );
    if (!defined $old_hidden || $HIDE != $old_hidden || $old_level != $hide_level) {
	hideshow();
    }
}

sub init_hideshow {
    setup_changed();
    $Irssi::scripts::hideshow::hide_next = undef;
}

sub UNLOAD {
    show_lines();
}

sub prt_text_issue {
    ($dest) = @_;
    if (ref $dest && $Irssi::scripts::hideshow::hide_next) {
	$dest->{hide} = 1;
    }
    $Irssi::scripts::hideshow::hide_next = undef;
}

sub prt_text_ref {
    return unless ref $dest;
    my ($win) = @_;
    if ($HIDE) {
	my $wid = $win->{_irssi};
	my $view = $win->view;
	my $lp = $view->{buffer}{cur_line};
	my $prev = $lp->prev;
	if ($prev && ($dest->{hide} || $lp->{info}{level} & $hide_level)) {
	    my $level = $lp->{info}{level};
	    $level |= $ext_hidden_level if $dest->{hide};
	    push @{ $hidden{ $wid }
			{ $prev->{_irssi} }
		    }, [ $lp->get_text(1), $level, $lp->{info}{time} ];
	    $view->remove_line($lp);
	    delete @{ $hidden{ $wid } }
		{ (grep {
		    $view->{buffer}{first_line}{info}{time} > $hidden{$wid}{$_}[-1][2]
		} keys %{$hidden{$wid}}) };
	    $view->redraw;
	}
    }
    $dest = undef;
}

sub fix_lines {
    my ($view, $rem_line, $prev_line) = @_;
    for my $wid (keys %hidden) {
	my $nl = delete $hidden{$wid}{ $rem_line->{_irssi} };
	if ($nl && $prev_line) {
	    push @{ $hidden{$wid} { $prev_line->{_irssi} } }, @$nl
	}
    }
}

sub win_del {
    my ($win) = @_;
    delete $hidden{ $win->{_irssi} };
}
Irssi::signal_register({
    'gui textbuffer line removed' => [ qw/Irssi::TextUI::TextBufferView Irssi::TextUI::Line Irssi::TextUI::Line/ ]
});

Irssi::signal_add_last({
    'setup changed'    => 'setup_changed',
    'gui print text finished' => 'prt_text_ref',
    'gui textbuffer line removed' => 'fix_lines',
});
Irssi::signal_add({
    'print text'	      => 'prt_text_issue',
    'window destroyed'	      => 'win_del',
});
Irssi::settings_add_level( setc, set 'level', '' );
Irssi::settings_add_bool( setc, set 'hide', 1 );
init_hideshow();

{ package Irssi::Nick }
