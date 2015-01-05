
use strict;

my $str = '{bbb {qwe}, ccc [1,2,3], ddd:"asd sdbfkjd ehrjqgewvj,sadfnlksdf.,", fff: qwewer }';

sub parse_str {
	my $str = shift;
	my %hash;
	my @array = split(//, $str);
	use Data::Dumper;
	#print Dumper(\@array);
	my $first = 1;
	my $f_not_parse = 0;
	my $f_is_colon = 0;
	my $f_in_quotes = 0;
	foreach my $el (@array) {
		if ($first) {
			$first = 0;
		    next;
		}
		if ($el eq '{' or $el eq '[') {
            $f_not_parse = 1;
            next;
		}
		if ($el eq '}' or $el eq ']') {
            $f_not_parse = 0;
            next;
		}
		if ($f_not_parse) {
			print $el;
		}
		if ($el eq ':') {
			$f_is_colon = 1;
		}
		if ($f_is_colon) {
            print $el;
            if ($el eq '"') {
                $f_in_quotes = 1;
                next;
            }
            if ($f_in_quotes) {
            	print $el;
            	if ($el eq '"') {
            		$f_in_quotes = 0;
            	} 

            }

		}
         
	} 

}

parse_str($str);