#!/usr/bin/perl

while ($line = <>) {
  $line =~ /^<\/body/ and system("cat end.inc.html");
  $line =~ /<title>/ and $line =~ /<\/title>/ and next;
  print $line;
  $line =~ /^<head>/ and system("cat head.inc.html");
  $line =~ /^<body/ and system("cat body.inc.html");
}

