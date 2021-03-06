use strict;
use 5.12.0;
use ExtUtils::MakeMaker;
use Config ();

# The additional \n helps to fool Module::Install
sub MY::test_via_harness { "\tprove --lib --rc=t/proverc t\n" }

my $mysql = `which mysql`;
chomp $mysql;
$mysql ||= '(null)';
my $mysqladmin = `which mysqladmin`;
chomp $mysqladmin;
$mysqladmin ||= '(null)';

print <<EOM;
mysql and mysqladmin executables:
 + mysql: $mysql
 + mysqladmin: $mysqladmin
EOM

if ( $mysql eq '(null)' || $mysqladmin eq '(null)' ) {
    print STDERR <<EOM;
Hmm, I couldn't find mysql and/or mysqladmin executables.
STF tests requires 'mysql' and 'mysqladmin' to be in available in our PATH.
Please make sure to put them in to build/test this application.

    export PATH=/path/to/mysql/bin:\$PATH
    perl Makefile.PL
    make test

EOM
}

my $queue_type = $ENV{STF_QUEUE_TYPE} || 'Q4M';
WriteMakefile(
    NAME => "STF",
    VERSION_FROM => 'lib/STF.pm',
    LICENSE => "artistic_2",
    AUTHOR    => 'Daisuke Maki C<< <daisuke@endeworks.jp> >>',
    PREREQ_PM => {
        'Cache::Memcached::Fast' => 0,
        'Data::Page' => 0,
        'Data::FormValidator' => 0,
        'Data::Localize' => 0,
        'Digest::MurmurHash' => 0,
        'DBI' => 0,
        'DBD::mysql' => 0,
        'DBIx::DSN::Resolver::Cached' => '0.04',
        'Email::MIME' => 0,
        'Email::Send' => 0,
        'Furl' => '0.38',
        'HTML::FillInForm::Lite' => 0,
        'HTTP::Parser::XS' => 0,
        'IPC::SysV' => 0,
        'Log::Minimal' => '0.14',
        'Math::Round' => 0,
        'Mojolicious' => '3.84',
        'Mouse' => '1.05',
        'Net::SNMP' => 0,
        'Plack' => '1.0013',
        'Plack::Middleware::ReverseProxy' => 0,
        'Plack::Middleware::Session' => 0,
        'Plack::Middleware::Static' => 0,
        'Plack::Request' => 0,
        'Plack::Session' => 0,
        'Parallel::ForkManager' => '0.7.9',
        'Parallel::Scoreboard' => '0.03',
        'Router::Simple' => 0,
        'SQL::Maker' => 0,
        'Scope::Guard' => 0,
        'Starlet' => 0,
        'String::Urandom' => 0,
        'Task::Weaken' => 0,
        'Text::MultiMarkdown' => 0,
        'Text::Xslate' => '1.6001',
        'YAML' => 0,
        'STF::Dispatcher::PSGI' => '1.09',
        # Add this requirement if the environment asks for it
        ( $queue_type eq 'Schwartz' ? ( 'TheSchwartz' => 0 ): () ),
        ( $queue_type eq 'Redis'    ? ( 'Redis'       => 0 ): () ),
        ( $queue_type eq 'Resque'   ? ( 'Resque'      => 0 ): () ),
        ( $Config::Config{use64bitint} ? () : ("Bit::Vector" => 0, "Math::BigInt" => 0) ),
    },
    BUILD_REQUIRES => {
        # For tests
        'App::Prove' => 0,
        'Proc::Guard' => 0,
        'Test::TCP' => 0,
        'Test::mysqld' => 0,
        'Test::MockTime' => 0,
        'Plack::Middleware::Reproxy' => '0.00002',
    },
    clean => {
        FILES => 't/*.log t/store* trace.db',
    }
);

