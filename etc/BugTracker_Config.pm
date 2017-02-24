# If you use a custom EmailSubjectTagRegex already, it's recommended to copy
# these lines into your own RT_SiteConfig.pm.

Set( $DistributionSubjectTagAllowed, qr/[a-z0-9 ._-]/i );
Set( $EmailSubjectTagRegex, qr/$EmailSubjectTagRegex(?:\s+$DistributionSubjectTagAllowed+)?/ );

# Necessary because RT_Config.pm's default is evaluated before we change the
# regex above.
Set( $ExtractSubjectTagNoMatch, qr/\[$EmailSubjectTagRegex #\d+\]/ );

# Translate distribution search strings from their canonical names,
# like Data::Dumper, to their queue name, like Data-Dumper.
#Set(%DistributionToQueueRegex,
#    'Pattern' => '::',
#    'Substitution' => '-'
#);

1;
