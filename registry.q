cwd:system"cd"
show "running from ",cwd

/set the port where we want to run on
show "checking port"
if[0i=system"p";system"p 1111"]

/load the schema of the tables that we want to use in this service
show "loading schema"
system"l ",cwd,"/schema/registry.q"


/make a record for the registry - other KDB services can connect to this and check
`.reg.registry insert (`global;`registry;.z.h;system"p")


/define some code that can be used to register an instance and also get the instances as and when needed
\d .reg

getConstraint:{[f;r;h;p]
	c:();
	if[not null f;c:c,enlist((=;`farm;enlist(f)))];
	if[not null r;c:c,enlist((=;`resource;enlist(r)))];
	if[not null h;c:c,enlist((=;`host;enlist(h)))];
	if[not p=-1;c:c,enlist((=;`port;p))];
	c}

register:{[record]
	`.reg.registry insert record}

exists:{[f;r;h;p]
	r:?[`.reg.registry;
		getConstraint[f;r;h;p];
		0b;
		()];
	$[0<count r;1b;0b]}

getAll:{[f;r;h;p]
	?[`.reg.registry;
		getConstraint[f;r;h;p];
		0b;
		()]}

getUrl:{[f;r;h;p]
	r:?[`.reg.registry;((=;`farm;enlist`f);(=;`resource;enlist`r);(=;`host;enlist`h);(=;`port;p));0b;`host`port];
	hsym `$(":" sv string raze first r)
	}

\d .