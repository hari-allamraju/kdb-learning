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

register:{[record]
	`.reg.registry insert record}

exists:{[f;r;h;p]
	r:?[`.reg.registry;((=;`farm;enlist`f);(=;`resource;enlist`r);(=;`host;enlist`h);(=;`port;p));0b;()];
	$[0<count r;1b;0b]}

getAll:{[]
	?[`.reg.registry;();0b;()]}

getServ:{[f;r;h;p]
	?[`.reg.registry;((=;`farm;enlist`f);(=;`resource;enlist`r);(=;`host;enlist`h);(=;`port;p));0b;()]}

\d .