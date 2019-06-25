#!/usr/bin/perl

## 停權扣金幣 batch 執行結果通知##

use CGI;
use lib "/usr/local/perl/modules";

 
$query = new CGI;

print $query->header;
&check_data($query);
#---END----------------------------

sub check_data() {
my($query) = @_;

//$email=$query->param(email);
$title="怪物十三支大改版，防弊刺激免費玩";
$serialno=$query->param(serialno);
$email="deo.chen@gigamedia.com.tw";
$now = time();
##sending email
   open (TEMPLATE, "template.html.template") || die("Cannot open html");
   @lines = <TEMPLATE>;
   close(TEMPLATE);
   open (OUTFILE, ">/tmp/tmpLS2OBEDM.txt") || die("Cannot open tmp error");


foreach $line (@lines) {
 chomp $line;
 if ($line =~ m|To.<!-EMAIL-!>|) {
    print OUTFILE ("To: $email\n");
 }
 elsif ($line =~ m|Subject: <!-TITLE-!>|){
    print OUTFILE ("Subject: $title\n");
 } 
 elsif ($line =~ m|^<!-SERIALNO-!>|){
    print OUTFILE ("$serialno\n");
 } 
 else {
    print OUTFILE "$line\n";
 }
}
   close(OUTFILE);

   $cmd = "/usr/lib/sendmail -t < /tmp/tmpLS2OBEDM.txt >& /dev/null";
   system($cmd);

}
