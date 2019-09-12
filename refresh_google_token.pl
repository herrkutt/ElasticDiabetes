#!/usr/bin/perl
use strict;
use warnings;

my $curl = `curl --output /home/<user>/google-fit/token.json --request POST --data "client_id=BLAH&client_secret=BLAHBLAH&refresh_token=BLAHBLAHBLAH&grant_type=refresh_token" https://www.googleapis.com/oauth2/v4/token`;

print($curl);


#1)FIRST OPEN A BROWSER AND GO TO HERE WITH THE CREDENTIALS OF A WEB CLIENT API FROM GOOGLE:
#https://accounts.google.com/o/oauth2/auth?client_id=BLAH&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.activity.read+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.blood_glucose.read+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.blood_pressure.read+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.body.read+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.body_temperature.read+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.location.read+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.nutrition.read+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.oxygen_saturation.read+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Ffitness.reproductive_health.read&access_type=offline&response_type=code

#2)LOGIN TO GOOGLE AND AFTER AUTHORIZING GET THE AUTHENTICATION CODE
#Authentication Code: 4/FaKeAuThEnTiCaTiOnCoDe_12345

#3) RUN THIS CURL COMMAND TO GET A REFRESH TOKEN
#curl --request POST --data "code=4/FaKeAuThEnTiCaTiOnCoDe_12345&client_id=BLAH&client_secret=BLAHBLAH&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://www.googleapis.com/oauth2/v4/token

#4) PUT THE REFRESH TOKEN, CLIENT ID & CLIENT_SECRET INTO THE my $curl COMMAND ABOVE
