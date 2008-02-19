use inc::Module::Install;

RTx('RT-BugTracker');

name            ('RT-BugTracker');
abstract        ('Adds a UI designed for bug-tracking for developers to RT');
all_from        ('lib/RT/BugTracker.pm');
license         ('GPL version 2');

WriteAll();
