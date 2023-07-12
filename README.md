<!--
SPDX-FileCopyrightText: Victor-ray, S. <zendaiowl@skiff.com>
SPDX-License-Identifier: CC0-1.0
-->

# Translate

---

WiP - _Work in progress_

Recently created the repository, it represents an idea I've had for a while, I have no idea when I'll be able to proceed with it nad it's entirely possible someone else will complete it before me.

A local translation app for Nextcloud using Argos-Translate or possibly LibreTranslate. 

I've had this idea for a while now and decided to create the repository and slowly start working on it. I'm currently at the end of my undergraduate degree and so it will take a while but I haven't seen anyone else starting on this idea since I started thinking about approximately a year or so ago, as such here it is. 

[Argos-Translate](https://github.com/argosopentech/argos-translate)

[Argos-Translate Files](https://github.com/dingedi/argos-translate-files)

[Argos-Translate Translate-HTML](https://github.com/argosopentech/translate-html)

[Argos-Translate Pre-Trained Models](https://www.argosopentech.com/argospm/index/)

[LibreTranslate](https://github.com/LibreTranslate/LibreTranslate)

[LibreTranslate-Models](https://github.com/argosopentech/LibreTranslate-Models)

[LibreTranslate-sh](https://github.com/argosopentech/LibreTranslate-sh)

[Tinytranslate](https://github.com/argosopentech/tinytranslate)

---

Place this app in **nextcloud/apps/**

## Building the app

The app can be built by using the provided Makefile by running:

    make

This requires the following things to be present:
* make
* which
* tar: for building the archive
* curl: used if phpunit and composer are not installed to fetch them from the web
* npm: for building and testing everything JS, only required if a package.json is placed inside the **js/** folder

The make command will install or update Composer dependencies if a composer.json is present and also **npm run build** if a package.json is present in the **js/** folder. The npm **build** script should use local paths for build systems and package managers, so people that simply want to build the app won't need to install npm libraries globally, e.g.:

**package.json**:
```json
"scripts": {
    "test": "node node_modules/gulp-cli/bin/gulp.js karma",
    "prebuild": "npm install && node_modules/bower/bin/bower install && node_modules/bower/bin/bower update",
    "build": "node node_modules/gulp-cli/bin/gulp.js"
}
```


## Publish to App Store

First get an account for the [App Store](http://apps.nextcloud.com/) then run:

    make && make appstore

The archive is located in build/artifacts/appstore and can then be uploaded to the App Store.

## Running tests
You can use the provided Makefile to run all tests by using:

    make test

This will run the PHP unit and integration tests and if a package.json is present in the **js/** folder will execute **npm run test**

Of course you can also install [PHPUnit](http://phpunit.de/getting-started.html) and use the configurations directly:

    phpunit -c phpunit.xml

or:

    phpunit -c phpunit.integration.xml

for integration tests
