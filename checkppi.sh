for f in figures/*[gG]; do echo -n "$f   "; identify -format "%x x %y" -units PixelsPerInch  $f;done
