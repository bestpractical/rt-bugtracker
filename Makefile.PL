use inc::Module::Install;

RTx('RT-BugTracker');

abstract_from   ('lib/RT/BugTracker.pm');
license         ('GPL version 2');
all_from        ('lib/RT/BugTracker.pm');

WriteAll();
