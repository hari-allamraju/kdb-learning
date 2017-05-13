/simple schema for the registry
\d .reg
registry:([];
	farm:`symbol$();
	resource:`symbol$(); 
	host:`symbol$(); 
	port:`int$())
\d .