Include Audience

/// custom.rg.Pick
/// See <code>custom.rg.GetPicsRule</code> for related code.
/// 
/// @docs https://github.com/registerguard/pick
/// @copyright Copyright (c) 2013 Micky Hulse.
/// @license Released under the Apache License, Version 2.0.
/// http://www.apache.org/licenses/LICENSE-2.0
/// @version 1.1.0
/// @created Monday, January 7, 2013
/// @modified Monday, January 28, 2013
Class custom.rg.Pick Extends %RegisteredObject
{

/// @param story { mixed } A dt.cms.schema.CMSStory object or a valid CMSStory ID (required).
/// @param position { %String } Picture item position (required).
/// @param include { %String } Include only these priorities (comma delimited list).
/// @param exclude { %String } Exclude only these priorities (comma delimited list).
/// @param items { %String } Number of CMSPicture objects to return; the default number '0', which returns all CMSPictures.
/// @param order { %String } Custom ORDER BY, used in SQL statement.
ClassMethod pics(
	story As dt.cms.schema.CMSStory = -1,
	position As %String = "",
	include As %String = "",
	exclude As %String = "",
	items As %Integer = 0,
	order As %String = "") As %ListOfObjects
{
	
	/**
	 * Trims white space and builds a list.
	 *
	 * set items = "foo, bar, baz"
	 * $$$lister(items) // "items" is now a list.
	 *
	 * @todo Force %list argument into a string before processing? Example: set %list = %list _ ""
	 *
	 * @see https://groups.google.com/d/topic/intersystems-public-cache/8iJV1p3kwD8/discussion
	 * @see https://gist.github.com/4008569
	 *
	 * @param %list { string } Comma delimited list; this argument must be passed as a variable (not a string).
	 * @return { $list } The %list parameter as a $list.
	 */
	
	#define lister(%list)                                                                   ##Continue
		set temp = ""                                                                       ##Continue
		for ##Unique(new)=1:1:$length(%list, ",") {                                         ##Continue
			set temp = temp _ $listbuild($zstrip($piece(%list, ",", ##Unique(old)), "<>W")) ##Continue
		}                                                                                   ##Continue
		set %list = temp                                                                    ##Continue
		kill temp
	
	/*----------------------------------*/
	
	/**
	 * Creates an array of key => values.
	 * WARNING: Must be called in order that they appear in SQL statement!
	 *
	 * $$$pbuild("areaID")
	 * $$$pbuild("sectionId")
	 * w params(1)
	 * // someMethod(params...)
	 *
	 * @see http://docs.intersystems.com/cache20091/csp/docbook/DocBook.UI.Page.cls?KEY=GOBJ_methods#GOBJ_methods_args_variable
	 * @see https://groups.google.com/d/topic/dti-lightning/5avEj-4twNE/discussion
	 *
	 * @param %v { mixed } Key value for "params" array.
	 * @return { array } Numerically indexed array of values.
	 */
	
	#define pbuild(%v) set params($increment(params)) = %v
	
	/*--------------------------------------------------------------------*/
	
	; Get RULE debug:
	set debug = ##class(dt.cms.support.Rules).getDebug()
	
	; Initialze the return value:
	set return = ##class(%ListOfObjects).%New()
	
	; dt.cms.schema.CMSStory?
	set:($isobject(story)) story = story.%Id() // Get its ID.
	
	; Check required arguments:
	if ($isvalidnum(story) && $length(position)) {
		
		; Start building the query:
		set sql = "SELECT DISTINCT "
		
		; Make items a whole number integer (or "0" if invalid):
		set items = (items \ 1) // https://groups.google.com/d/topic/intersystems-public-cache/gFvXTNjgq7o/discussion
		
		; Items?
		if (items) {
			
			; Setup "params" array for required input parameters:
			$$$pbuild(items)
			
			; Amend query:
			set sql = sql _ "TOP ? "
		
		}
		
		; Continue building the query:
		set sql = sql _ 
		          "cmspm.CMSPicture AS CMSPicture " _ 
		          "FROM dt_cms_schema.CMSPictureMapping cmspm " _ 
		          "INNER JOIN dt_cms_schema.CMSPicture cmsp " _ 
		          "ON (cmsp.ID = cmspm.CMSPicture) " _ 
		          "INNER JOIN dbo.FileHeader fh " _ 
		          "ON fh.fileHeaderId = cmsp.fileheaderId " _ 
		          "INNER JOIN dt_cms_schema.CMSStory cmss " _ 
		          "ON (cmss.ID = cmspm.cmsStory) " _ 
		          "INNER JOIN dbo.ForeignDbLink fdbl " _ 
		          "ON (fdbl.fileHeaderId = cmsp.fileheaderId) " _ 
		          "AND (fdbl.foreignidField = 'story.storyId') " _ 
		          "INNER JOIN dbo.Story story " _ 
		          "ON (story.ID = cmss.story) " _ 
		          "AND (story.storyId = fdbl.foreignId) " _ 
		          "INNER JOIN dt_cms_schema.CMSPictureVersion cmspv " _ 
		          "ON (cmspv.ID = cmsp.TheCMSPictureVersion) "
		
		; Position (already validated):
		$$$pbuild(position)
		
		; Append query:
		set sql = sql _ "WHERE cmspm.position = ? "
		
		; Story (IBID):
		$$$pbuild(story)
		
		; Append query:
		set sql = sql _ "AND cmss.ID = ? "
		
		; Includes?
		if ($length(include)) {
			
			; Convert comma delimited string of CMSPicture priorit(y/ies) "indludes" into a $list:
			$$$lister(include)
			
			; Add include list to params:
			$$$pbuild(include)
			
			; Amend query:
			set sql = sql _ "AND fh.priorityId %INLIST ? "
			
		}
		
		; Excludes?
		if ($length(exclude)) {
			
			; Convert comma delimited string of CMSPicture priorit(y/ies) "excludes" into a $list:
			$$$lister(exclude)
			
			; Add exclude list to params:
			$$$pbuild(exclude)
			
			; Amend query:
			set sql = sql _ "AND fh.priorityId NOT %INLIST ? "
			
		}
		
		; Append ORDER BY:
		set sql = sql _ "ORDER BY " _ $select($length(order):order, 1:"fdbl.viewOrder") // ORDER BY custom value OR fdbl.viewOrder (ASC) by default.
		
		/*
		
		-- Copy/paste friendly:
		
		SELECT DISTINCT
			cmspm.CMSPicture AS CMSPicture, fdbl.viewOrder, cmsp.fileheaderId, fh.priorityId
		FROM
			dt_cms_schema.CMSPictureMapping cmspm
		INNER JOIN
			dt_cms_schema.CMSPicture cmsp
		ON
			(cmsp.ID = cmspm.CMSPicture)
		INNER JOIN 
			dbo.FileHeader fh 
		ON 
			fh.fileHeaderId = cmsp.fileheaderId
		INNER JOIN
			dt_cms_schema.CMSStory cmss
		ON
			(cmss.ID = cmspm.cmsStory)
		INNER JOIN
			dbo.ForeignDbLink fdbl
		ON
			(fdbl.fileHeaderId = cmsp.fileheaderId)
		AND
			(fdbl.foreignidField = 'story.storyId')
		INNER JOIN
			dbo.Story story
		ON
			(story.ID = cmss.story)
		AND
			(story.storyId = fdbl.foreignId)
		INNER JOIN 
			dt_cms_schema.CMSPictureVersion cmspv
		ON
			(cmspv.ID = cmsp.TheCMSPictureVersion)
		WHERE
			cmspm.position = '288pxw'
		AND
			cmss.ID = 29353870
		AND
			fh.priorityId NOT IN (4) 
		ORDER BY
			fdbl.viewOrder
		
		*/
		
		; Output debug?
		if (debug) {
			
			; The query:
			do ##class(dt.cms.support.Rules).debugRule(debug, "sql = " _ sql)
			
			; ClassMethod arguements:
			do ##class(dt.cms.support.Rules).debugRule(debug, "##class(custom.rg.Pick).pics(story=""" _ story _ """ position=""" _ position _ """ include=""" _ $listtostring(include, ", ") _ """ exclude=""" _ $listtostring(exclude, ", ") _ $case($isvalidnum(items, -1), 1:(""" items=""" _ $number(items, -1)), :"") _ """ order=""" _ order _ """)")
			
		}
		
		; Try/catch block required when using $$$dtThrow:
		try {
			
			; %importPackages:
			set packages = "" // Used for resolving unqualified table references (it's best, and faster, to fully qualify tables with their scheme).
			
			; No need for:
			//set rs = ##class(%ResultSet.SQL).%New() // http://docs.intersystems.com/cache20091/csp/docbook/DocBook.UI.Page.cls?KEY=GSQL_dynsql#GSQL_dynsql_resultset
			
			; Prepare and execute the query:
			set rs = ##class(%ResultSet.SQL).%Prepare(sql, .error, packages, params...) // @@UNS: Use $$$dtQueryGet(sql, params...)
			
			; An error will be a %SYSTEM.Error object:
			if ($isobject(error)) {
				
				; Throws if %sc is an error:
				$$$dtThrow($$$dtSysErr(error.Status),"Failed to execute: ##class(%ResultSet.SQL).%Prepare(""" _ $get(sql) _ """)")
				
			} else {
				
				; Initialize the status code:
				set sc = $$$OK
				
				//while (rs.%Next(.sc) && ($$$ISOK(sc))) { // Recommended to $$$ISERR() below.
				while (rs.%Next(.sc)) {
					
					; If there's a problem, exit the loop:
					quit:($$$ISERR(sc))
					
					; Return the results in a list:
					set sc = return.Insert(rs.CMSPicture) // Inserts an element with OREF value oref at the end of the list. Returns a %Status value indicating success or failure.
					
					; Throws if %sc is an error:
					$$$dtThrow(sc, "Failed to insert CMSPicture: return.Insert(" _ rs.CMSPicture _ ")")
					
				}
				
				$$$dtThrow(sc, "Failed to get query element: rs.%Next(.sc)")
				
				//do rs.Close() // Defunct. Better to use:
				kill rs // ... or set rs = ""
				
			}
			
		} catch(e) {
			
			; Throws if %sc is an error:
			$$$dtThrow(e.AsStatus(), "Something failed.")
			
		}
		
	} elseif (debug) {
		
		do ##class(dt.cms.support.Rules).debugRule(debug, "There's something wrong with your required parameters: $isvalidnum(story) = " _ $isvalidnum(story) _ ", $length(position) = " _ $length(position))
		
	}
	
	; Return the %ListOfObjects:
	quit return
}

}
