#!/usr/bin/perl
#
# CC-BY Stefan Müller (HU Berlin)
#

#use strict;
use warnings;

my $filename = $ARGV[0];           # store the 1st argument into the variable
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

open($fhout, '>:encoding(UTF-8)', "$filename.out")
  or die "Could not open file '$filename.out' for writing $!";


# create hashs of item and page number for occurances with footnote and for those without one
# in a second pass walk through all the footnote items
  # if there is an entry without footnote just drop the footnote item
  # if there is an entry without footnote before the footnote item and after the footnote item
    # turn the footnote item into an item without footnote

#my region;

while (my $row = <$fh>) {
  if ($row =~ /{([\p{L}\s!-:\.]*)\|([()]*)(?:hyperpage)?}\{([0-9]*)}/) { # normal index entries
    my $item     = $1;
    if ($2) {
        $region   = $2;
    } else {$region = "no";}
    my $page     = $3;
#    my $footnote = "no";
#    print "lang: $item, region: $region, page: $page\n";
    $itempage{"$item-$page"} = $region;
    print $fhout $row;
  } elsif ($row =~ /{([\p{L}\s!-:\.]*)\|hyperindexformat\{\\infn \{([0-9]*)}}}\{([0-9]*)}/) { #index entries in footnotes
    my $item = $1;
    my $page     = $3;
    my $footnote = $2;
    $itempagefn{"$item-$page"} = $footnote;
#    print "lang: $item, page: $page, fn: $footnote\n";
  } else { # Ups. This is cases with unicode, we cannot process with regular expressions.
#    print STDERR "Do not know what to do with: $row";
     print $fhout $row;
  }
}
 
close $fh;


foreach $key (keys %itempagefn)
{
  $key =~ /(.*)-(.*)/;
  $item=$1;
  $page=$2;
  $before=$page-1;
  $bbefore=$page-2;
  $after=$page+1;
  $aafter=$page+2;
  if (exists($itempage{"$item-$page"}))  { # there is an entry for item with and without footnote -> drop footnote
#      print "Print as no footnote: $item $page $itempage{\"$item-$before\"}\n";
    print STDERR "footnote and full entry on page, drop footnote\n";
  } elsif (exists($itempage{"$item-$before"}) && exists($itempage{"$item-$after"})) {
#      print "Print as no footnote: $item $page $itempage{\"$item-$before\"}\n";
    print $fhout "\\indexentry {$item|hyperpage}{$page}\n";
    print STDERR "footnote in the middle\n";
  } elsif (exists($itempage{"$item-$bbefore"}) && exists($itempage{"$item-$before"})) {
#      print "Print as no footnote: $item $page $itempage{\"$item-$before\"}\n";
    print $fhout "\\indexentry {$item|hyperpage}{$page}\n";
    print STDERR "footnote following two others\n";
  } elsif (exists($itempage{"$item-$after"}) && exists($itempage{"$item-$aafter"})) {
#      print "Print as no footnote: $item $page $itempage{\"$item-$before\"}\n";
    print $fhout "\\indexentry {$item|hyperpage}{$page}\n";
    print STDERR "footnote before two others\n";
  } else {
      print $fhout "\\indexentry {$item|infn {$itempagefn{$key}}}{$page}\n";
  }
}

close $fhout;

system("mv -f $filename.out $filename");


