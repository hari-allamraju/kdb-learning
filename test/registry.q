.tst.desc["Test the registry functions"]{
	should["Contain default entry for the registry itself"]{
		r:.reg.find . ````;
		1 musteq count r
	};
	should["Return a search result when found"]{
		r:.reg.find . `default```;
		1 musteq count r;
		1 musteq .reg.exists . `default```
	};
	alt{
		should["Be able to register a new instance"]{
			.reg.register (`test;`testresource;.z.h;`1234);
			1 musteq count .reg.find . `test```;
			1 musteq .reg.exists . `test```
		};
		after{
			.reg.deregister . `test```
		}
	};
	should["Be able to de-register a new instance"]{
		.reg.register (`test;`testresource;.z.h;`1234);
		1 musteq count .reg.find . `test```;
		1 musteq .reg.exists . `test```;
		.reg.deregister[`test;`testresource;.z.h;`1234];
		0 musteq count .reg.find . `test```;
		0 musteq .reg.exists . `test```
	};
	should["Return a false result when not found"]{
		r:.reg.find . `test```;
		0 musteq count r;
		0b musteq .reg.exists . `test```
	};

	};