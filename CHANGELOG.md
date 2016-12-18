# Changelog

## December 17 2016

* Bump to 2.1.0
* Fix bug that caused POST routes to be ignored if more than one was defined
* Many thanks to @njd5475 for the bug report and pull request that helped me write this

## April 28 2016

* Release 2.0.0
* Fix incompatibility between grape-route-helpers and grape 0.16.0

## April 11 2016

* Release 1.2.2
* Fixed incompatibility between grape-route-helpers and Ruby 2.3 by merging PR #8 from phallguy

## October 11 2015

* Release 1.2.1
* Fixed issue #4

## September 27 2015

* Release 1.2.0

* You can now assign custom helper names to Grape routes
* Fixed a bug where routes would be listed more than once in the rake task if they are mounted to another API
* Added the HTTP verb to rake task output

## July 5 2015

* You can now pass query parameters to helper functions in order to generate your own query string (Issue #1)

## June 28 2015

Release 1.0.1

* Rename rake task from `grape:routes` to `grape:route_helpers`

* If a Grape::Route has a specific format (json, etc.) in its route_path attribute, the helper will return a path with this extension at the end
