epub-testsuite
==============

_A collection of EPUB documents to systematically test EPUB Reading System conformance_

## Goal

This repository contains a collection of EPUB documents used for evaluating feature coverage in EPUB Reading Systems.

The primary focus of the collection is on human-evaluated binary (pass/fail) tests. Included tests are of two types: A) required and B) optional Reading System functionality. While the tests in category A are the ones used for "formal" specification conformance testing, the tests in category B are included since they nevertheless provide useful information.

The collection uses some fairly simple markup conventions to provide easy navigation and clarity, and to allow the automated generation of a results form template.

## Contributing

Following a few simple markup conventions, the process for adding a new test is:
       
1. Locate the, or create a new, content document to contain the test. (Note that content docs are themed by functionality areas.)     
2. Add a wrapper element with an ID and class='ctest' (for required Reading System functionality) or class='otest' (for optional Reading System functionality) 
3. Echo the ID value given in 2 above in a descendant element text node with class 'test-id'
4. Add the human readable description of the test intent inside the wrapper. Give the element the class 'desc'. The description typically has the form "Test whether [feature] is supported"
5. Add the evaluation criteria for the test pass/fail states inside the wrapper. This typically has the form "If [observable or invokable condition], the test passes".      
6. Add a link to the test in the navigation document (typically xhtml/nav.xhtml). Note that the Navigation Document serves as the self-documenting list of available tests. Each test, regardless of whether it is required or optional, is linked to from the nav doc using the wrapper ID mentioned above.

## Validation

Every book in the suite must pass [EPUBCheck](https://github.com/w3c/epubcheck) without errors, so that
anyone using the suite as a corpus can tell errors introduced by their own tool from errors already in the
books. A GitHub Actions workflow checks this on every pull request. To run the same check locally, download
an EPUBCheck release and run:

    $ util/epubcheck-all.sh path/to/epubcheck.jar

Warnings are reported but do not fail the check: some books deliberately keep deprecated constructs
because reading systems are tested against them.

## Download

You can download this project in either [zip](https://github.com/mgylling/epub-testsuite/zipball/master) or [tar formats](https://github.com/mgylling/epub-testsuite/tarball/master).

You can also clone the project with [Git](http://git-scm.com) by running:

    $ git clone git://github.com/mgylling/epub-testsuite

## Licensing

Copyright © 2012-2015 International Digital Publishing Forum (IDPF)

The EPUB Test Suite by the IDPF is licensed under a Creative Commons 4.0 International License (CC-BY 4.0).

More information about this license is available at:

   https://creativecommons.org/licenses/by/4.0/

More information about the IDPF is available at:

   http://wwww.idpf.org
