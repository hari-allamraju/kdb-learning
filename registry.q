\c 50 500
cwd:system"cd"
system"l ",cwd,"/utils.q"
system"l ",cwd,"/logging.q"

opts:.Q.def[`group`resource`logLevel!(`default;`registry;4)].Q.opt .z.x

.log.logLevel:opts`logLevel
.log.debug "Running from ",cwd


/set the port where we want to run on
if[0i=system"p";system"p 1111"]
p:string system"p"
.log.debug "Running on port",p

/load the schema of the tables that we want to use in this service
.log.debug "Loading schema"
system"l ",cwd,"/schema/registry.q"


/make a record for the registry - other KDB services can connect to this and check
host_ip:.utils.getIP[]
`.reg.registry insert (opts`group;opts`resource;`$host_ip;`$p)
.log.info "registered self on ",host_ip," with port ",p


/define some code that can be used to register an instance and also get the instances as and when needed
\d .reg

getConstraint:{[d]
	c:();
	if[not null f;c:c,enlist((=;`farm;enlist(f)))];
	if[not null r;c:c,enlist((=;`resource;enlist(r)))];
	if[not null h;c:c,enlist((=;`host;enlist(h)))];
	if[not null p;c:c,enlist((=;`port;enlist(p)))];
	c
	}

register:{[record]
	`.reg.registry insert record
	}

deregister:{[f;r;h;p]
	![`.reg.registry;
		getConstraint[f;r;h;p];
		0b;
		`$()]
	}
exists:{[f;r;h;p]
	r:?[`.reg.registry;
		getConstraint[f;r;h;p];
		0b;
		()];
	$[0<count r;:1b;:0b];
	}

find:{[f;r;h;p]
	?[`.reg.registry;
		getConstraint[f;r;h;p];
		0b;
		()]
	}

getUrl:{[f;r;h;p]
	r:?[`.reg.registry;
		getConstraint[f;r;h;p];
		0b;
		g!g:`host`port];
	hsym `$(":" sv string raze first r)
	}

\d .