#Generate all possible random 3-character strings of alphanumerics

perl -le '@c = ("a".."z",0..9);
          for $a (@c){for $b(@c){for $c(@c){
            print "$a$b$c"}}}' > all_3char.txt
