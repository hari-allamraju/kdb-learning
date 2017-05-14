\d .log
DEBUG:0
INFO:1
WARN:2
ERROR:3
OFF:4
logLevel:DEBUG

doLog:{show "    " sv (string .z.Z;x;y)}

debug:{
	if[DEBUG>=logLevel;doLog["DEBUG";x]]
	}

info:{
	if[INFO>=logLevel;doLog["INFO";x]]
	}

warn:{
	if[WARN>=logLevel;doLog["WARN";x]]
	}

error:{
	if[ERROR>=logLevel;doLog["ERROR";x]]
	}

debug["Initialized logging"]

\d .