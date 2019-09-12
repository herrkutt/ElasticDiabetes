#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use WWW::Mechanize;
use HTTP::Request;
use Time::HiRes qw(gettimeofday);
use Data::Dumper;

sub nanoToSecTimestamp {
	my $unixNanoTime = $_[0];
	#print "UnixNanoTime: $unixNanoTime\n";
	my $unix_timestamp = substr $unixNanoTime,0,13;
	return $unix_timestamp;
}

sub unixTimeToHuman {
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($_[0]);
	# necessary conversion of $mon and $year
	$mon += 1;
	$year += 1900;
	my $date = "$year-$mon-$mday $hour:$min:$sec";
	return $date;
}

# Thank you to: https://blog-en.openalfa.com/how-to-read-and-write-json-files-in-perl
my $json;
{
  local $/; #Enable 'slurp' mode
  open my $fh, "<", "/home/<user>/google-fit/token.json";
  $json = <$fh>;
  close $fh;
}
my $data_type = "Steps_1HR";
my $data = decode_json($json);
my $access_token = $data->{'access_token'};
#print $access_token;
my $aggregation = 0;
#$aggregation = 300000; #5rmin
$aggregation = 3600000; #1 hour
#$aggregation = 86400000; #24 hours
my $timestamp_now = int (gettimeofday * 1000);
my $timestamp_5minago = $timestamp_now - $aggregation;

my $timestamp_start = $timestamp_now - 86400000;
my $timestamp_end = $timestamp_now;

#print $timestamp_now . "   " . $timestamp_5minago . "\n";

#Thank you to: https://corion.net/curl2lwp.psgi
my $ua = WWW::Mechanize->new();
my $r  = HTTP::Request->new(
    'POST' =>
      'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
    [
        'Accept' => '*/*',
        'Authorization' => "Bearer $access_token",
        'Host'           => 'www.googleapis.com:443',
        'User-Agent'     => 'curl/7.55.1',
        'Content-Type'   => 'application/json;encoding=utf-8',
    ],
    '{
  "aggregateBy": [{
    "dataTypeName": "com.google.step_count.delta",
    "dataSourceId": "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
  }],
  "bucketByTime": { "durationMillis": ' . $aggregation . ' },
  "startTimeMillis": ' . $timestamp_start .',
  "endTimeMillis": ' . $timestamp_end .' 
}'
);

#https://metacpan.org/pod/HTTP::Response
my $response = $ua->request( $r, );
if ($response->is_success) {
	$data = decode_json($response->decoded_content);
	#print "key $_\n" for keys %{$data};
	#print $data->{'bucket'}[0]->{'dataset'}[0]->{'point'}[0]->{'value'}[0]->{'intVal'} . "\n\n\n";
	my $sum = 0;
	my $output = "";
	foreach my $bucket (@{ $data->{'bucket'}})
	{
		foreach my $dataset (@{ $bucket->{'dataset'} })
		{
			$output = "";
			foreach my $point (@{ $dataset->{'point'} })
			{
				my $unixNanoTime = %{$point}{'endTimeNanos'};
				my $unix_timestamp = nanoToSecTimestamp($unixNanoTime);
				$output = $output . $unix_timestamp;
				
				foreach my $value (@{ $point->{'value'} })
				{
					$output = $output . " $data_type " . %{$value}{'intVal'};
					
					print $output . "\n";
				}
			}
		
		}
	}
}
else {
    print STDERR $response->status_line, "\n";
}

#print "SUM: $sum \n";
