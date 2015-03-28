# Changelog

## v1.1.0
#### January 29, 2013

* Bumped version number to `v1.1.0`.
* `custom.rg.GetPicsRule.csr`:
	* Updated header comments:
		* Bumped version number.
		* Changed "Date" to "Created".
		* Added "Modified" date.
	* Modified `csr:attributes`:
		* Changed order of appearance.
		* Modified `items` comment to refelect latest change in functionality.
		* Tweaked spacing of `required` attributes.
	* Removed the default value of `items` `QuoteAttribute` to an empty string.
	* Added more comments to `<csr:action>` section of RULE.
	* Re-arranged order of call to `pics` ClassMethod.
	* Added safety check if `pics` returned `0` objects.
* `custom.rg.Pick.cls`:
	* Updated header comments:
		* Bumped version number.
		* Changed "Date" to "Created".
		* Added "Modified" date.
	* Moved param `items` to below `exclude` in doc block and ClassMethod arguements.
		* `items` default value is now 0, which will allow the code/query to return all pics by default.
	* Added new comment to `$$$pbuild` macro.
	* Moved the `debug` initialize to one level higher.
		* Added `debug` message to let people know that there's something wrong with the required arguments.
	* Discovered [a bug](https://groups.google.com/d/topic/intersystems-public-cache/gFvXTNjgq7o/discussion) with my number checking and squashed it.
	* Rearranged some lines of code.
	* Updated query:
		* It now respects `vieworder`.
		* Updated syntax to use newer ANSI JOINS.
	* Fixed/moved a few lines of code around.
* `demo.csp`:
	* Fixed custom `ORDER BY` to use `fh` instead of `fhdr` (as this alias changed in the SQL).
	* Moved `include` to before `items`, because I'm anal. :D
	* Removed `items` if I really wanted to return all pics (items used to be limited to "5" by default).

---

## v1.0.0
#### January 9, 2013

* Official public release.

---

## v0.0.0
#### January 7, 2013

* GitHub repository creation.

---

## vX.X.X
#### Mmmmm [D]D, YYYY

* ...

---