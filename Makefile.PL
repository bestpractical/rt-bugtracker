use inc::Module::Install;

RTx('RT-BugTracker');

all_from        ('lib/RT/BugTracker.pm');
readme_from     ('lib/RT/BugTracker.pm');

requires_rt('4.0.9');

WriteAll();
