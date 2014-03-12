# To use, place in ~/.irssi/scripts and load with /script load digraphs.pl
#
# It will capture control-k and the following two characters, and turn them
# into a single unicode character (inspired by the Vim editor)

use strict;
use utf8;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '0.1';
%IRSSI = (
    authors     => 'Josh Holland',
    contact     => 'jrh@joshh.co.uk',
    name        => 'Digraph',
    description => 'Allow easy insertion of unicode symbols',
    license     => 'GPLv3'
);

my %digraphs = (
    '!I'	=>	'¡',
    Ct		=>	'¢',
    Pd		=>	'£',
    Cu		=>	'¤',
    Ye		=>	'¥',
    BB		=>	'¦',
    SE		=>	'§',
    "':"	=>	'¨',
    Co		=>	'©',
    '-a'	=>	'ª',
    '<<'	=>	'«',
    NO		=>	'¬',
    Rg		=>	'®',
    "'m"	=>	'¯',
    DG		=>	'°',
    '+-'	=>	'±',
    '2S'	=>	'²',
    '3S'	=>	'³',
    "''"	=>	'´',
    My		=>	'µ',
    PI		=>	'¶',
    '.M'	=>	'·',
    "',"	=>	'¸',
    '1S'	=>	'¹',
    '-o'	=>	'º',
    '>>'	=>	'»',
    '14'	=>	'¼',
    '12'	=>	'½',
    '34'	=>	'¾',
    '?I'	=>	'¿',
    'A!'	=>	'À',
    "A'"	=>	'Á',
    'A>'	=>	'Â',
    'A?'	=>	'Ã',
    'A:'	=>	'Ä',
    AA		=>	'Å',
    AE		=>	'Æ',
    'C,'	=>	'Ç',
    'E!'	=>	'È',
    "E'"	=>	'É',
    'E>'	=>	'Ê',
    'E:'	=>	'Ë',
    'I!'	=>	'Ì',
    "I'"	=>	'Í',
    'I>'	=>	'Î',
    'I:'	=>	'Ï',
    'D-'	=>	'Ð',
    'N?'	=>	'Ñ',
    'O!'	=>	'Ò',
    "O'"	=>	'Ó',
    'O>'	=>	'Ô',
    'O?'	=>	'Õ',
    'O:'	=>	'Ö',
    '*X'	=>	'×',
    'O/'	=>	'Ø',
    'U!'	=>	'Ù',
    "U'"	=>	'Ú',
    'U>'	=>	'Û',
    'U:'	=>	'Ü',
    "Y'"	=>	'Ý',
    TH		=>	'Þ',
    ss		=>	'ß',
    'a!'	=>	'à',
    "a'"	=>	'á',
    'a>'	=>	'â',
    'a?'	=>	'ã',
    'a:'	=>	'ä',
    aa		=>	'å',
    ae		=>	'æ',
    'c,'	=>	'ç',
    'e!'	=>	'è',
    "e'"	=>	'é',
    'e>'	=>	'ê',
    'e:'	=>	'ë',
    'i!'	=>	'ì',
    "i'"	=>	'í',
    'i>'	=>	'î',
    'i:'	=>	'ï',
    'd-'	=>	'ð',
    'n?'	=>	'ñ',
    'o!'	=>	'ò',
    "o'"	=>	'ó',
    'o>'	=>	'ô',
    'o?'	=>	'õ',
    'o:'	=>	'ö',
    '-:'	=>	'÷',
    'o/'	=>	'ø',
    'u!'	=>	'ù',
    "u'"	=>	'ú',
    'u>'	=>	'û',
    'u:'	=>	'ü',
    "y'"	=>	'ý',
    th		=>	'þ',
    'y:'	=>	'ÿ',
    '..'	=>	'…',
);

my $got_action_key;
my $first;
sub dispatch {
    my $key = shift;
    if ($key == 11) {
	$got_action_key = 1;
	return
    }
    if ($got_action_key) {
	unless ($first) {
	    $first = $key;
	    Irssi::signal_stop;
	    return;
	}
	my $first_char = chr $first;
	my $second_char = chr $key;
	my $digraph = $first_char . $second_char;
	$got_action_key = $first = 0;

	my $char = $digraphs{$digraph} || $second_char;
	Irssi::signal_continue(ord $char);
    }
}

Irssi::signal_add "gui key pressed", \&dispatch;
