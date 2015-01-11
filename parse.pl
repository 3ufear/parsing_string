
use strict;
use warnings;
my $str = 'bbb {}, ccc [1,"]]{52}","3"]; ddd:"asd sdbfkjd ehrj[[[qgewvj,sadfnlksdf.,"; aaa {qqq},fff: "qwewer", ccc:[]';
$str = ' bbb {}, ccc: {}, ddd: []';

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
	my $f_in_close_quotes = 0;
	my $first_time = 0;
	my @array_1;
	my @parse_string;
	my $string;
	my $error = 0;
	foreach my $el (@array) {
		if ($f_in_quotes) {
			if ($el eq '"') {
                 $f_in_close_quotes = 1;
                 $string .= $el;
                 next;
            }
            if ($f_in_close_quotes) {
                 if ($el eq ' ') {
                 	$string .= $el;
                 	next
                 } elsif (($el eq ',' || $el eq ';')&& $#array_1 == -1 ) {
                 	push @parse_string, $string;
                 	$string = '';
                 	$f_in_close_quotes = 0;
                 	$f_in_quotes = 0;
                 	next;
                 } elsif (($el eq ',' || $el eq ']' || $el eq '}') && $#array_1 != -1 ) {

                 	$f_in_close_quotes = 0;
                 	$f_in_quotes = 0;
                 	if ($el eq ']' || $el eq '}') {
                 	    my $cur_el = pop @array_1;
                        if ($cur_el eq '{') {
            	            $cur_el = '}'; 
                        } elsif ($cur_el eq '[') {
            	            $cur_el = ']';
                        }

                        if ($cur_el ne $el) {
                            $error = 1;
                            last;
                        }
                        if ($#array_1 == -1) {
                            $f_not_parse = 0;
                        }
                    }
                }
            } 
            $f_in_close_quotes = 0;
            $string .= $el;
            next;
        }
        if (($el eq ','  || $el eq ';' ) && !$f_not_parse && !$f_in_quotes ) {
        	push @parse_string, $string;
            $string = '';
        	next;
             
        }
		if ($el eq '{' or $el eq '[') {
			$string .= $el;
            $f_not_parse = 1;
            push @array_1, $el;
            next;
		}
		if ($el eq '}' or $el eq ']') {
			$string .= $el;
            my $cur_el = pop @array_1;
            if ($cur_el eq '{') {
            	$cur_el = '}'; 
            } elsif ($cur_el eq '[') {
            	$cur_el = ']';
            }

            if ($cur_el ne $el) {
                $error = 1;
                last;
            }
            if ($#array_1 == -1) {
                $f_not_parse = 0;
            }
            next;
		}
		if ($el eq '"') {
			$string .= $el;
            $f_in_quotes = 1;
            next;
        }

     $string .= $el;    
	} 
	push @parse_string, $string;
    return $error ? 'error' : \@parse_string;
}

print Dumper(parse_str($str));