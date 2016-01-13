#Generate all possible random 3-character strings of alphanumerics
#$a is the first position, $b is the second position, $c is the third position, etc.

perl -le '@c = ("a".."z",0..9);
          for $a (@c){for $b(@c){for $c(@c){
            print "$a$b$c"}}}' > all_3char.txt


#Same thing, whitespace

#perl -le '@c = ("a".."z",0..9);
#          for $a (@c){
#          	for $b(@c){
#          		for $c(@c){
#		            print "$a$b$c"
#		        }
#		    }
#		}' > all_3char.txt
