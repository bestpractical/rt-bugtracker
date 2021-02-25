use inc::Module::Install;

RTx('RT-BugTracker');

repository('https://github.com/bestpractical/rt-bugtracker');

requires_rt('4.2.0');
rt_too_new('4.6.0');

no_index( package => 'RT::Queue' );

WriteAll();
