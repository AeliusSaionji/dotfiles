{
	my %control2format_d = (
		'a' => 'F',
		'c' => '_',
		'e' => '|',
		'i' => '#',
		'f' => 'I',
		'g' => 'n',
	   );
	my %control2format_c = (
		"\c_" => 'U',
		"\cV" => '8',
	   );
	my %base_bg = (
		'0' => '0',
		'1' => '4',
		'2' => '2',
		'3' => '6',
		'4' => '1',
		'5' => '5',
		'6' => '3',
		'7' => '7',
		'8' => 'x08',
		'9' => 'x09',
		':' => 'x0a',
		';' => 'x0b',
		'<' => 'x0c',
		'=' => 'x0d',
		'>' => 'x0e',
		'?' => 'x0f',
	   );
	my %base_fg = (
		'0' => 'k',
		'1' => 'b',
		'2' => 'g',
		'3' => 'c',
		'4' => 'r',
		'5' => 'm', # p
		'6' => 'y',
		'7' => 'w',
		'8' => 'K',
		'9' => 'B',
		':' => 'G',
		';' => 'C',
		'<' => 'R',
		'=' => 'M', # P
		'>' => 'Y',
		'?' => 'W',
	   );

	my $to_true_color = sub {
		my (@rgbx) = map { ord } @_;
		$rgbx[3] -= 0x20;
		for (my $i = 0; $i < 3; ++$i) {
			if ($rgbx[3] & (0x10 << $i)) {
				$rgbx[$i] -= 0x20;
			}
		}
		my $color = $rgbx[0] << 16 | $rgbx[1] << 8 | $rgbx[2];
		($rgbx[3] & 0x1 ? 'z' : 'Z') . sprintf '%06X', $color;
	};

	my %ext_color_off = (
		'.' =>  [0, 0x10],
		'-' =>  [0, 0x60],
		',' =>  [0, 0xb0],
		'+' =>  [1, 0x10],
		"'" =>  [1, 0x60],
		'&' =>  [1, 0xb0],
	   );
	my @ext_color_al = (0..9, 'A' .. 'Z');
	my $to_ext_color = sub {
		my ($sig, $chr) = @_;
		my ($bg, $off) = @{ $ext_color_off{$sig} };
		my $color = $off - 0x3f + ord $chr;
		$color += 10 if $color > 213;
		($bg ? 'x' : 'X') . (1+int($color / 36)) . $ext_color_al[$color % 36];
	};
	sub control2format {
		my $line = shift;
		$line =~ s/%/%%/g;
		$line =~ s{( \c_ | \cV )
			     |(?:\cD(?:
						([aceigf])
					   |(?:\#(.)(.)(.)(.))
					   |(?:([-.,+'&])(.))
					   |(?:(?:/|([0-?]))(?:/|([/0-?])))
					   |\xff/|(/\xff)
				   ))
			  }{
				  '%'.(defined $1  ? $control2format_c{$1}         :
					   defined $2  ? $control2format_d{$2}         :
					   defined $6  ? $to_true_color->($3,$4,$5,$6) :
					   defined $8  ? $to_ext_color->($7,$8)        :
					   defined $10 ? ($base_bg{$10} . (defined $9 ? '%'.$base_fg{$9} : '')) :
					   defined $9  ? $base_fg{$9} :
					   defined $11 ? 'o' : 'n')
			  }gex;
		$line
	}
}
