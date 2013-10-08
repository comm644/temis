

function getElementsByTagNames(list,obj) 
{
	if (!obj) {
            obj = document;
        }
	var tagNames = list.split(',');
	var resultArray = new Array();
	for (var i=0;i<tagNames.length;i++) {
		var tags = obj.getElementsByTagName(tagNames[i]);
		for (var j=0;j<tags.length;j++) {
			resultArray.push(tags[j]);
		}
	}
	var testNode = resultArray[0];
	if (!testNode) return [];
	if (testNode.sourceIndex) {
		resultArray.sort(function (a,b) {
				return a.sourceIndex - b.sourceIndex;
		});
	}
	else if (testNode.compareDocumentPosition) {
		resultArray.sort(function (a,b) {
				return 3 - (a.compareDocumentPosition(b) & 6);
		});
	}
	return resultArray;
}
function createTOC()
{
	var toc = document.createElement('div');
	toc.id = 'innertoc';

	/*
	var a = toc.appendChild(document.createElement('span'));
	a.onclick = showhideTOC;
	a.id = 'contentheader';
	a.innerHTML = 'show page contents';
	var z = toc.appendChild(document.createElement('div'));
	z.onclick = showhideTOC;
	*/
	
	var toBeTOCced = getElementsByTagNames('h1,h2,h3,h4,h5');
	if (toBeTOCced.length < 2) return false;
	
	var ol = document.createElement('ol');
	toc.appendChild( ol );
	
	var levels = new Array();
	levels["H1"] = 1;
	levels["H2"] = 2;
	levels["H3"] = 3;
	levels["H4"] = 4;
	
	var curLevel = 1;
	var stack = new Array();
	var li = ol;

	if (toBeTOCced.length>0 ) 	toBeTOCced[0].id="#top";

	for (var i=0;i<toBeTOCced.length;i++) {
		
		var level = levels[toBeTOCced[i].nodeName];
		
		if ( level > curLevel ) {
			stack[curLevel] = ol;
			var newOL = document.createElement('ol');
			li.appendChild( newOL );
			ol = newOL;
			curLevel = level;
		}
		else if ( level < curLevel ) {
			curLevel = level;
			ol = stack[curLevel];
		}
		else {
			//nothing
		}

		li = document.createElement( 'li');
		ol.appendChild( li );

		var link = document.createElement('a');
		li.appendChild( link );
		
		link.innerHTML = toBeTOCced[i].innerHTML;
		link.className = 'page';

		var headerId = toBeTOCced[i].id || 'link' + i;
		link.href = '#' + headerId;
		toBeTOCced[i].id = headerId;

		var top=document.createElement('a');
		top.innerHTML = 'Top';
		top.href = '#top';
		top.style.fontSize='small';
		top.style.styleFloat= 'right';
		top.className = 'topLink';	
		if ( top.styleFloat ) top.styleFloat= 'right';
		toBeTOCced[i].appendChild( top );
		
		/*
		if (toBeTOCced[i].nodeName == 'H2') {
			link.innerHTML = 'Top';
			link.href = '#top';
			toBeTOCced[i].id = 'top';
		}
		*/
	}
	return toc;
}

var TOCstate = 'block';

function showhideTOC() {
	TOCstate = (TOCstate == 'none') ? 'block' : 'none';
	var newText = (TOCstate == 'none') ? 'show page contents' : 'hide page contents';
	document.getElementById('contentheader').innerHTML = newText;
	document.getElementById('innertoc').lastChild.style.display = TOCstate;
}


function insertTOC()
{
	if ( document.getElementById('toc') == null ) {
		var header = document.createElement("H2");
		header.innerHTML = "Table of contents";

		var div = document.createElement("div");

		var hider = document.createElement('div');
		hider.id = 'contentheader';
		hider.innerHTML = "hide";
		hider.onclick = showhideTOC;
	
		div.appendChild( header );
		//div.appendChild( hider );

		var anchor = document.getElementsByTagName('H1')[0];
		if ( anchor == null ) {
			anchor = document.getElementsByTagName('body')[0];
			anchor.insertBefore( div, body.firstChild );
		}
		else {
			anchor.parentNode.insertBefore( div, anchor.nextSibling );
		}
		
	
		div.id = "toc";
		div.appendChild( createTOC() );
	}
	else {
		document.getElementById('toc').appendChild( createTOC() );
	}
}

