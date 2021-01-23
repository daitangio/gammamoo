
- [Introduction](#introduction)
- [Getting Started With LambdaMOO](#getting-started-with-lambdamoo)
- [How to Add New Built-In Functions to the MOO Language](#how-to-add-new-built-in-functions-to-the-moo-language)
- [Resources](#resources)

# Introduction

Please refer to https://github.com/daitangio/toaststunt
for a more advanced implementation, based on more recent Lambdamoo efforts and patches

WARNING: If you are upgrading an existing LambdaMOO database from an earlier
version of the server, you should read the relevant notes in ChangeLog.txt
regarding DB changes you may need to make *before* doing the upgrade.  Such
notes are marked in ChangeLog.txt with the string `NOTE'.

------------------------------------------------------------------------------

# Getting Started With LambdaMOO


LambdaMOO has been successfully compiled and tested on several machines and
operating systems; see INSTALL.md

To start the server, use a command like this:

	./moo INITIAL-DB-FILE CHECKPOINT-DB-FILE

where INITIAL-DB-FILE is the name of an existing LambdaMOO database file and
CHECKPOINT-DB-FILE is the filename the server should use for its periodic
checkpoints of the current DB, which is otherwise kept only in its memory.  IT
IS STRONGLY ADVISED that you not use the same file name for both
INITIAL-DB-FILE and CHECKPOINT-DB-FILE; this could, in the event of a crash,
leave you with no useful DB file at all.

Included with the release is a little shell script called `restart' that
handles the server start-up in a more convenient way.  You type a command like

	./restart FOOBAR

and the script does the following:

  -- If FOOBAR.db.new exists, then
       + Rename FOOBAR.db to FOOBAR.db.old, and start a background process to
	 compress that file.
       + Rename FOOBAR.db.new to FOOBAR.db
  -- Start the server in the background, reading the initial DB from FOOBAR.db
     and writing the checkpoints to FOOBAR.db.new.  The server's log of network
     connections, checkpoints, and errors will be put into FOOBAR.log.  If
     there was already a file named FOOBAR.log, its old contents are appended
     to FOOBAR.log.old and FOOBAR.log is removed first.

The `restart' script is really the only good way to start up the server; it's
all I ever use for LambdaMOO itself.

If your server gets a lot of use and your users start getting the error message
    *** Sorry, but the server cannot accept any more connections right now.
    *** Please try again later.
when they try to connect, it's because your server has run out of UNIX file
descriptors.  If you'd like to allow more folks to connect, you'll have to bump
up the limit (though there's a hard limit in the UNIX kernel that you won't be
able to exceed).  To bump up the limit as far as it will go, remove the `#' at
the beginning of the line
    #unlimit descriptors
in the `restart' script before starting up your server.

For most of the networking options supported by the server, both the `moo' and
`restart' commands take an optional argument for changing some network
connection information; type just `./moo' to see what the argument is for the
option you've chosen.  The only one for which you're at all likely to want to
override the default concerns the NP_TCP networking options; for them, the
optional argument is the TCP port number on which the server should listen for
new connections (the default is 7777).

The `moo' command can take an optional first argument `-e'; if provided, the
server does not start accepting connections immediately after loading the
database file.  Instead, using its standard input and output streams, it enters
`emergency wizard mode', in which you can list and (re)set verb programs,
execute MOO expressions and programs, etc.  This mode is useful for recovering
from having made terrible mistakes in the database, perhaps by reprogramming
crucial verbs in such a way as to make it impossible to log in as usual.  Type
`help' in this mode to see a complete list of available emergency commands.

The only database included with the release is Minimal.db.  Getting from there
to something usable is possible, but tedious; see README.Minimal for details.

Also available for FTP from ftp.parc.xerox.com is a version of LambdaCore.db, a
snapshot of the core pieces of the LambdaMOO database.  New snapshots are made
at irregular intervals as sufficient changes happen to the LambdaMOO database.

The LambdaMOO Programmer's Manual is also available for FTP from the same
place.  It comes in plain-text, Texinfo, and Postscript formats.

Once the database has been loaded, the server reacts to various standard UNIX
process signals as follows:

	Signal(s)			Action
	---------			------
	FPE				Ignored
	HUP (if it was already		Ignored
	     being ignored)
	HUP (otherwise)			Panic the server
	ILL, QUIT, SEGV, BUS		Panic the server
	INT, TERM, USR1			Shut down the server cleanly
	USR2				Schedule a checkpoint ASAP

For the most part, this just means that the following commands might be useful
to you:
	kill -INT <server-pid>		Cleanly shut down the server
	kill -USR2 <server-pid>		Make the server write a checkpoint soon

If you're using an NP_TCP networking configuration, then if you do a `ps'
command you should see either three or four UNIX processes concerned with the
running server.  The one with the lowest process number (probably) is the main
server itself, the program that's actually executing MOO commands, etc.  The
next two processes are associated with the way the MOO server does lookups of
network host names; by using extra (smallish) processes for this, the server
can robustly recover from nameserver flakiness.  The fourth process is only
present from time to time; it is a copy of the main server process that is
`checkpointing,' writing out a copy of the database into a file.  On many
systems (wherever possible), the server changes the output of the `ps' command
to show you explicitly which of these processes is which.

Finally, if you're putting up a LambdaMOO server, you should probably be a
member of the MOO-Cows mailing list.  Send email to MOO-Cows-Request@Xerox.Com
saying just `subscribe' to get yourself added to the list.

	Pavel Curtis
	aka Lambda
	aka Haakon
	Archwizard of LambdaMOO

	Pavel@Xerox.Com



# How to Add New Built-In Functions to the MOO Language


Implement your functions by following the many examples in the distributed
server code (e.g., in the file `numbers.c').  Then follow the directions in the
comment at the top of functions.c.

Alternatively, save a copy of the distributed file `extensions.c' and then edit
the original to implement your new functions.  The C function
`register_extensions()' is already called at server startup to register
whatever built-in functions are implemented in `extensions.c'.  In future
releases, you can simply replace the newly distributed `extensions.c' with your
own.

NOTE that, in this release, I'm not making any guarantees about what interfaces
within the server will remain stable.  Thus, any code you add to the server may
well be horribly broken by a future release.  Your best bet for avoiding this
cruel fate is to send that code to me and convince me to add it to the
distribution; that way, I'll fix up your code for each new release.

------------------------------------------------------------------------------

	    Machines On Which Version 1.8.0 of LambdaMOO Was Tested
	    -------------------------------------------------------

    Hardware	    Operating System(s)	  Networking Options    Compiler
    --------	    -------------------	  ------------------    --------
    Sun 4/SPARC	    SunOS 4.1.3, 5.5	  SU, BT, BL, VT, VL    GCC
    SGI Iris	    IRIX 5.3		  SU, BT, BL, VT, VL	Vendor's
    DEC Alpha	    DEC OSF/1 V3.2	  SU, BT, BL,     VL	Vendor's
    Intel x86	    Linux 1.3.30	  SU, BT, BL,     VL	GCC

Key to `Networking Options' codes:

    Code	NETWORK_PROTOCOL    NETWORK_STYLE
    ----	----------------    -------------
     SU		   NP_SINGLE	        -----
     BT		   NP_TCP		NS_BSD
     BL		   NP_LOCAL		NS_BSD
     VT		   NP_TCP		NS_SYSV
     VL		   NP_LOCAL		NS_SYSV

# Resources

Tutorial: https://www.darksleep.com/notablog/articles/LambdaMOO_Programming_Tutorial
FAQ: http://www.moo-cows.com/docs/faqs/new-archwiz-faq.html
