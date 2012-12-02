 # Chagelog

##  version 0.0.2 
### more bugfixes
commit fc72fdc5b23ea146d37554151eb7681bb0f615ee
Date:   Sun Dec 2 20:25:26 2012 +0200

    add fixes for running rspec in cleaner environment and increased version
    where platform indpendant gem should be used

commit a24dc9f1458a7e200b825c62c9ecd96836fa378e
Date:   Sun Dec 2 17:08:17 2012 +0200

    reworked popen usage for legacy runy versions and win/mac
    incompatabilities

commit f4c578a2974b19e594e6180ca2ad5a27e4edc5ba
Date:   Thu Nov 29 17:07:27 2012 +0200

    fix problem with pipes on windows

commit 94d611475656105b72680dca8aebac6ca7ab3344
Date:   Wed Nov 28 10:46:16 2012 +0200

    rework adding library to search path for win and mac

### Bug fix
commit fd83634f375f76fb7ef5af72516f6afe6f07946c
Date:   Tue Nov 27 13:24:24 2012 +0200

    fixed travis build 13 (removed unneded gem used only for debugging)


### Bug fix
commit c021cdfc0e59b8160b684363d4c1a2bcf29472dc
Date:   Tue Nov 27 13:03:50 2012 +0200

    Fixed using of Notifier class and added some smoother handling of test exe outputs

### Bug fix
commit 5e3a8ae87abdff852b6e1917728ea792b4d11274
Date:   Sun Nov 25 17:24:59 2012 +0200

    rework parsing for cunit

### Bug fix
commit c93acec12fad9698b2a134bb316c92aa38a74c8f
Date:   Sun Nov 25 11:20:01 2012 +0200

    fixed test for parsing output from test

### Bug fix
commit 1a09331f89b5b0e3e72cd1b4b15551f7ed8c4b1b
Date:   Sun Nov 25 09:13:23 2012 +0200

    fixed guard reload calls and added test cases for passing cunit test output to parser


### Bug fix
commit 901dee0b5f8b14311885b4264bbb5fa1951161eb
Date:   Wed Nov 21 14:01:07 2012 +0200

    fixed rspec test running under windows platform


### Bug fix
commit 40da4a4c79c6ec5a7abefb09813ff953ce94e7e4
Date:   Tue Nov 20 13:39:11 2012 +0200

    test&fix for stopping guard's tasks and exiting, when one of them(tasks) fails

### Bug fix
commit 622488393175bb396a82a2f235bab9241fbe922a
Date:   Sun Nov 18 17:06:41 2012 +0200

    merged stdout and stderr outputs when spawning/piping tasks

### Improvement
commit b305b860e6e0dbed2006ab8a8775f1c352ce8139
Date:   Sun Nov 18 11:37:28 2012 +0200

    removed doc folder, since it is generated automatically with 'rake doc'

### Improvement
commit ad4dd6a13f290c31fb149ccd1ae9a0b65f8c5774
Date:   Fri Nov 16 00:42:51 2012 -0500

    skip interactions for guard run within rspec

## version 0.0.1

### Improvement
commit f246fc98f17959c59ef1525e56ebb70472ced89f
Date:   Tue Nov 6 20:06:33 2012 +0200

    added specific platform to gemspec since not yet tested on other platforms

### Improvement
commit a7fda4f1d8f7b0fb937aa0e20f5b37cac55323a0
Date:   Tue Nov 6 20:04:59 2012 +0200

    added specific platform to gem sinc still not tested on other platforms

### Improvement
commit 0ef39baec6dbcfe7da55286417420811baf194e3
Date:   Tue Nov 6 19:45:44 2012 +0200

    leave with class variable access but make it portable

### Improvement
commit c62e832c478b5690bd02a68399b22d3177df35b3
Date:   Tue Nov 6 19:34:14 2012 +0200

    reworked the tests

### Bugfix
commit decab60a968b1a1fc926e5edd00acecc8f2c2d80
Date:   Tue Nov 6 19:12:59 2012 +0200

    fixed rspec tests

### Improvement
commit 6dc936e6dc829353ee8433c1136333de07ae9781
Date:   Fri Nov 2 07:59:40 2012 +0200

    Some fixes to improve rake

### Improvement
commit 548da4659f9b982151c354533fac1104131e779c
Date:   Mon Oct 15 19:39:32 2012 +0300

    update gem

### Bug fix
commit 34978668aa7b26441a9a79c0eac38134cbd43fa4
Date:   Mon Oct 15 19:29:30 2012 +0300

    Fix cunit parser tests

### Bugfix
commit 62a192b47082cd00154fe7a6e3663430453bde47
Date:   Fri Oct 12 18:52:35 2012 +0300

    more test pass

### Improvement
commit b1bdec45bf9ce9dde9e9ef1a067e3fec4461960d
Date:   Fri Oct 12 07:55:37 2012 +0300

    add parser tests

### Bugfix
commit 1f6e251023c15b5092e16873afe552b1ea2eabcb
Date:   Sat Oct 6 21:59:29 2012 +0300

    fix run on change

### Bugfix
commit 06b4cd83ac895713a78754783b37c5e0f74e06a9
Date:   Sat Oct 6 21:58:26 2012 +0300

    fix the test

commit e62d28d6031cbc4664cf2fb8fd4a8ad172f8224e
Date:   Sat Oct 6 21:52:08 2012 +0300

    fix the test

### Improvement
commit aadbd9ad9ce9ae841f678718c931af9707fa2601
Date:   Sat Oct 6 21:50:37 2012 +0300

    enhance the test expect some info

### Improvement
commit 0e85a5b2cd2596c11826dec04f4da81d0723ae95
Date:   Sat Oct 6 21:45:04 2012 +0300

    add test for run_on_change

### Bugfix
commit 5f076ef6362a8f66508bae263c57b23c75566b73
Date:   Thu Oct 4 21:34:49 2012 +0300

    fix build - only pending tests should remain not covered
    changed puts method with GUI.info

### Improvement
commit e5d0783f8d49b4b39934dde0ab867cd8032c4d5d
Date:   Wed Oct 3 08:43:49 2012 +0300

    add tests for the Cunit output parser

### Improvement
commit b5b5fb18245618c4e0d2969c51f16890969c5cac
Date:   Sun Sep 23 08:53:05 2012 -0400

    travis_build_status_to_readme

### Improvement
commit d9c74c868184f3d0a76f36d295c4be8be5b51e89
Date:   Sun Sep 23 08:44:37 2012 -0400

    use expand_path instead of absolute_path

### Bugfix
commit da363416aeceac84ce463a48b18b5434e145ae47
Date:   Sun Sep 23 08:32:57 2012 -0400

    fixed init of runner object

commit b7a8e79a9ac8533792c5c75c47d9165d1e95a3a6
Date:   Sat Sep 22 19:22:31 2012 +0300

    just test the travis

commit 782ffc3050fded2e516ce3587363b5f830c65e01
Date:   Sat Sep 22 19:18:48 2012 +0300

    fix rake and travis

### Improvement
commit 01f2967fc970a234f43c5899bcd90d919337996d
Date:   Sat Sep 22 17:52:06 2012 +0300

    added some more documentation and cleanup of dead code

### Improvement
commit 3746ac25267b63a0c1f93e9d0bfc699d0da89b63
Date:   Fri Sep 21 18:32:43 2012 +0300

    Moved runner behaviour in a separate class and fixed Guardfile format

commit e690c19158d6a511ba4e07bd4a48bf765609f0cf
Date:   Fri Sep 21 18:30:23 2012 +0300

    Moved runner behaviour in a separate class and fixed Guardfile format

commit 4372dfab33a65fba622685d3e8ca09eff09948ba
Date:   Fri Sep 21 18:29:49 2012 +0300

    Moved runner behaviour in a separate class and fixed Guardfile format

#### Bugfix
commit e1713aa0e01e7777a966beca23da83e07135f8a3
Date:   Fri Sep 21 18:28:56 2012 +0300

    fixed gemspec not to include gemfiles

### Improvement
commit 1c054c79f1068c633b059118f9854fc0344bde0f
Date:   Fri Sep 21 18:25:11 2012 +0300

    Added rdoc output :) - will improve

### Improvement
commit 667c9fc5e6a16059f9f493c95b0f00880c0a6006
Date:   Fri Sep 21 18:15:56 2012 +0300

    Fixed dependancy to guard and added meaningful README

commit 30678f36d96ed1337f27186f0daf5e4e1340198f
Date:   Fri Sep 21 18:12:06 2012 +0300

    Moved runner behaviour in a separate class and fixed Guardfile format
