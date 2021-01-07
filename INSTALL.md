LambdaMOO has been successfully compiled and tested on several machines and
operating systems; a table appears at the end of this file.

Unix/LINUX PREREQUISITES
LambdaMOO require yacc (parser) and gperf  (perfect hash function generator)

On Ubuntu/Debian install yacc and gperf with:
sudo apt install -y bison gperf

COMPILATION

People compiling on any of these machines should only need to do the following:
  -- run the command `sh configure'; it will take a couple of minutes, trying
     out various features of your operating system, figuring out which of a
     long list of known quirks must be patched around for your system.  It will
     produce a fair amount of output as it runs, every line of it beginning
     with the word `checking'.  When it's finished poking at your system, it
     will print out a little note concerning which networking options will work
     on your particular machine.  Make a note of these, since they'll constrain
     your choice of edits in the next step.
  -- edit the file `options.h', choosing the options appropriate to your needs
     and your local configuration.  In particular, this is where you specify
     the kind of networking the server should support, choosing from the
     options printed by `configure' in the first step.
  -- type `make'; the code should compile with *almost* no errors or warnings.
     The exception is warnings about code in files from your own system;
     an amazing number of systems contain header files and other files that
     don't compile without warnings.  Obviously, I can't do anything about
     these files, so just ignore such warnings.

That should do it, you'll now have a working LambdaMOO server.
	[EXCEPTION: If you've defined NETWORK_PROTOCOL to be NP_LOCAL in
	`options.h', then you will also need a specialized client program
	for connecting to the server.  Type either `make client_bsd' or
	`make client_sysv', depending on how you defined NETWORK_STYLE, to
	create the appropriate client program.]

If you're not on one of these configurations, you may still get lucky.  You
will need the following things:

  -- You need a C compiler that is at least mostly compliant with the ANSI C
     standard.  Old-style, purely Kernighan & Ritchie compilers will fail
     miserably.  The more closely it adheres to the standard, the less trouble
     you'll have.
  -- You need support for signals, forking, and pausing, preferably according
     to the POSIX standard; if you haven't got POSIX, then I might be ready for
     your particular non-standard system anyway.
  -- You need an implementation of the crypt() password-encryption function
     that comes with all BSD UNIX operating systems.

If you've got all of this, then try the above procedure (i.e., type 
`sh configure', edit `options.h', and type `make') and there's a good chance
that it will just work.  If so, please let me know so that I can add your
machine and operating system to the table at the end of this file.  If not,
feel free to send me mail and I'll help you try to make it work.
