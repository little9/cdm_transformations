 #!/usr/bin/perl

    use strict;
    use warnings;

    my $dir = '.';

    opendir(DIR, $dir) or die $!;

    print '<cdmFiles>';

    while (my $file = readdir(DIR)) {

        # Use a regular expression to ignore files beginning with a period
        next if ($file =~ m/^\./);
        
	print "<cdmFile filename='$file'>$file</dumpSet>\n";
	

    }

    print '</dump>';
    
    closedir(DIR);
    exit 0;
