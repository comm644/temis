/** Some XML Document cross-browser stuff
	(c) 2008 Alexei V. Vasilyev. All Rights Reserved.
 */

window.document.__haveDomCopying = 2;
window.document.haveDomCopying = function()
{
	if ( this.__haveDomCopying != 2 ) return this.__haveDomCopying == 1;
	var testval  = "attribute-test";
	var value = this.body.className;
	this.body.setAttribute("class", testval);
	var isHave = this.body.className == testval;
	this.body.className = value;

	__haveDomCopying = isHave;
	return isHave;
}

window.document.__haveRuntimeScriptLoading = 2;

window.document.haveRuntimeScriptLoading = function()
{
	if ( this.__haveRuntimeScriptLoading != 2 ) return this.__haveRuntimeScriptLoading == 1;
	
	var s = this.createElement("script");
	var c = this.createTextNode("window.document.__haveRuntimeScriptLoading=1;");
	try {
		s.appendChild(c);
		var body = this.getElementsByTagName("body")[0];
		body.appendChild( s );
	}
	catch (e){
		this.__haveRuntimeScriptLoading = 0; //IE
	}

	if( this.__haveRuntimeScriptLoading == 2 ) {
		this.__haveRuntimeScriptLoading = 0;
	}
	var isHave = this.__haveRuntimeScriptLoading == 1;
	return isHave;
}
	

window.document.importNode = function( sourceNode, deep )
{
	
	if ( !sourceNode ) return;
 	if ( sourceNode.nodeType == 3) { //catch textnode
 		return this.createTextNode( sourceNode.data );
 	}
	var target = this.createElement( sourceNode.tagName );

	if ( sourceNode.attributes ){
		for( var n=0; n < sourceNode.attributes.length; ++n ) {
			var at = sourceNode.attributes[n];
			target.setAttribute( at.nodeName, at.nodeValue);
		}
	}
	
	for( var n=0; n <sourceNode.childNodes.length; ++n ) {
		var child =  this.importNode( sourceNode.childNodes[n], deep );
		if ( child ) target.appendChild(child );
	}
	return target;
}

window.document.isNonClosedTag = function( name )
{
	var htmlTags = [ "INPUT", "BR", "HR" ];
	name = name.toUpperCase(name);
	for( i in htmlTags ) {
		if ( name == htmlTags[i] ) return true;
	}
	return false;
}
	
window.document.nodeToHTML = function( el  )
{
	if ( !el ) return "";
	if ( el.nodeType == 3) { //catch textnode
 		return el.nodeValue;
 	}
	
	var str ="<" + el.nodeName + " ";
	if ( el.attributes ){
		for( var n=0; n < el.attributes.length; ++n ) {
			var at = el.attributes[n];
			var s = at.nodeName + "=\"" + at.nodeValue  + "\" ";
			str += s;
		}
	}
	str +=">";
	for( var n=0; n <el.childNodes.length; ++n ) {
		var child=  el.childNodes[n];
		str += this.nodeToHTML( child);
	}
	if ( !document.isNonClosedTag( el.nodeName ) ) {
		str += "</" + el.nodeName + ">";
	}
	return str;
}

window.document.nodeToString = function( el, prefix )
{
	if ( !el ) return "";
	if ( el.nodeType == 3) { //catch textnode
 		return prefix + el.nodeValue + "\n";
 	}
	if ( prefix == null ) prefix = "";
	
	var str = prefix + "<" + el.nodeName + " ";
	if ( el.attributes ){
		for( var n=0; n < el.attributes.length; ++n ) {
			var at = el.attributes[n];
			if ( at.nodeValue == null ) continue;
			if ( at.nodeValue == "" ) continue;
			if ( at.nodeValue == "inherit" ) continue;
			var s = at.nodeName + "=\"" + at.nodeValue  + "\" ";
			str += s;
		}
	}
	str +=">\n";
	for( var n=0; n <el.childNodes.length; ++n ) {
		var child=  el.childNodes[n];
		str += this.nodeToString( child, prefix + " " );
	}
	str += prefix + "</" + el.nodeName + ">\n";
	return str;
}
